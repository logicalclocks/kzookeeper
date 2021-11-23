# providers/default.rb
#
# Copyright 2014, Simple Finance Technology Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

def initialize(new_resource, run_context)
  super
  @user            = new_resource.user
  @group           = new_resource.user
  @version         = new_resource.version
  @mirror          = new_resource.mirror
  @checksum        = new_resource.checksum
  @install_dir     = new_resource.install_dir
  @data_dir        = new_resource.data_dir
  @install_dir_res = zk_install_dir(@install_dir)
  @data_dir_res    = zk_data_dir(@data_dir)
  @zk_source       = zk_source("zookeeper-#{@version}")
  @zk_install_cmd  = zk_install_command('install zookeeper')
end

# Install Zookeeper
action :install do
  @zk_source.path(zk_download_path)
  @zk_source.owner('root')
  @zk_source.mode(00644)
  @zk_source.source(zk_source_constructed)
  @zk_source.checksum(@checksum)
  @zk_source.run_action(:create)

  @install_dir_res.owner(@user)
  @install_dir_res.group(@group)
  @install_dir_res.recursive(true)
  @install_dir_res.mode(00700)
  @install_dir_res.run_action(:create)

  @data_dir_res.owner(@user)
  @data_dir_res.group(@group)
  @data_dir_res.recursive(true)
  @data_dir_res.mode(00700)
  @data_dir_res.run_action(:create)

  unless zk_installed?
    Chef::Log.info("Zookeeper version #{@version} not installed. Installing now!")
    @zk_install_cmd.cwd(Chef::Config['file_cache_path'])
    @zk_install_cmd.command <<-eos
tar -C #{@install_dir} -zxf zookeeper-#{@version}.tar.gz
chown -R #{@user}:#{@group} #{@install_dir}
    eos
    @zk_install_cmd.run_action(:run)
  end
end

action :uninstall do
  Chef::Log.error("Unimplemented method :uninstall for resource `zookeeper'")
end

private

def zk_source(path = '')
  Chef::ResourceResolver.resolve(:remote_file).new(path, @run_context)
end

def zk_data_dir(path = '')
  Chef::ResourceResolver.resolve(:directory).new(path, @run_context)
end

def zk_install_dir(path = '')
  Chef::ResourceResolver.resolve(:directory).new(path, @run_context)
end

def zk_install_command(cmd = '')
  Chef::ResourceResolver.resolve(:execute).new(cmd, @run_context)
end

def zk_installed?
  ::File.exist?(::File.join(@install_dir, "zookeeper-#{@version}", "zookeeper-#{@version}.jar"))
end

def zk_source_constructed
  ::File.join(@mirror, "zookeeper-#{@version}", "zookeeper-#{@version}.tar.gz")
end

def zk_download_path
  ::File.join(Chef::Config['file_cache_path'], "zookeeper-#{@version}.tar.gz")
end
