# recipes/config_render.rb
#
# Copyright 2013, Simple Finance Technology Corp.
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

# set the config path based on default attributes

zookeeper_fqdn = consul_helper.get_service_fqdn("zookeeper")
zookeepers = []
node['kzookeeper']['default']['private_ips'].each_with_index do |ipaddress, index|
  id=index+1
  node.override['kzookeeper']['config']["server.#{id}"]="#{id}.#{zookeeper_fqdn}:2888:3888"
  zookeepers.push("#{id}.#{zookeeper_fqdn}")
end

node.override['kzookeeper']['servers'] = zookeepers

config_path = ::File.join(node['kzookeeper']['conf_dir'], 'zoo.cfg')

# render out our config
kzookeeper_config config_path do
  config node['kzookeeper']['config']
  user   node['kzookeeper']['user']
  action :render
end

template "#{node['kzookeeper']['conf_dir']}/jaas.conf" do
  source 'jaas.conf.erb'
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  action :create
  mode '0750'
end