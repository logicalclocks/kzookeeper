group node['kzookeeper']['group'] do
  gid node['kzookeeper']['group_id']
  action :create
  not_if "getent group #{node['kzookeeper']['group']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

user node['kzookeeper']['user'] do
  action :create
  uid node['kzookeeper']['user_id']
  gid node['kzookeeper']['group']
  shell "/bin/false"
  system true
  not_if "getent passwd #{node['kzookeeper']['user']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

group node['kzookeeper']['group'] do
  action :modify
  members ["#{node['kzookeeper']['user']}"]
  append true
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

directory "#{node['kzookeeper']['dir']}" do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  mode "775"
  action :create
  not_if { File.directory?("#{node['kzookeeper']['dir']}") }
end

directory "#{node['kzookeeper']['install_dir']}" do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  mode "750"
  action :create
end

crypto_dir = x509_helper.get_crypto_dir(node['kzookeeper']['user'])
kagent_hopsify "Generate x.509" do
  user node['kzookeeper']['user']
  crypto_directory crypto_dir
  action :generate_x509
  not_if { node["kagent"]["enabled"] == "false" }
end

service_name="zookeeper"

case node['platform_family']
when "debian"
  systemd_script = "/lib/systemd/system/#{service_name}.service"
when "rhel"
  systemd_script = "/usr/lib/systemd/system/#{service_name}.service"
end


# Pre-Experiment Code

require 'json'
include_recipe 'java'

kzookeeper "#{node['kzookeeper']['version']}" do
  user        node['kzookeeper']['user']
  mirror      node['kzookeeper']['mirror']
  checksum    node['kzookeeper']['checksum']
  install_dir node['kzookeeper']['install_dir']
  data_dir    node['kzookeeper']['config']['dataDir']
  action      :install
end

link node['kzookeeper']['base_dir'] do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  to node['kzookeeper']['home']
end

include_recipe "kzookeeper::config_render"

template "#{node['kzookeeper']['home']}/bin/zookeeper-start.sh" do
  source "zookeeper-start.sh.erb"
  owner node['kzookeeper']['user']
  group node['kzookeeper']['user']
  mode 0770
end

template "#{node['kzookeeper']['home']}/bin/zookeeper-stop.sh" do
  source "zookeeper-stop.sh.erb"
  owner node['kzookeeper']['user']
  group node['kzookeeper']['user']
  mode 0770
  variables({
              :zk_dir => node['kzookeeper']['home']
            })
end

template "#{node['kzookeeper']['home']}/bin/zookeeper-status.sh" do
  source "zookeeper-status.sh.erb"
  owner node['kzookeeper']['user']
  group node['kzookeeper']['user']
  mode 0770
  variables({
              :zk_dir => node['kzookeeper']['home']
            })
end

directory "#{node['kzookeeper']['data_volume']['root_dir']}" do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  mode "750"
  action :create
end

directory "#{node['kzookeeper']['data_volume']['data_dir']}" do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  mode "750"
  action :create
end

bash 'Move kzookeeper data to data volume' do
  user 'root'
  code <<-EOH
    set -e
    # Make sure zookeeper is stopped before moving the directory
    systemctl stop zookeeper
    mv -f #{node['kzookeeper']['data_dir']}/* #{node['kzookeeper']['data_volume']['data_dir']}
    rm -rf #{node['kzookeeper']['data_dir']}
  EOH
  only_if { conda_helpers.is_upgrade }
  only_if { File.directory?(node['kzookeeper']['data_dir'])}
  not_if { File.symlink?(node['kzookeeper']['data_dir'])}
end

link node['kzookeeper']['data_dir'] do
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  mode '0750'
  to node['kzookeeper']['data_volume']['data_dir']
end

template systemd_script do
  source 'zookeeper.service.erb'
  owner 'root'
  group 'root'
  action :create
  mode '0755'
  notifies :restart, "service[#{service_name}]", :delayed
end

service "#{service_name}" do
  supports :status => true, :restart => true, :start => true, :stop => true
  provider Chef::Provider::Service::Systemd
  if node['services']['enabled'] == "true"
    action :enable
  end
end

found_id=-1
id=1
my_ip = my_private_ip()

for zk in node['kzookeeper']['default']['private_ips']
  if my_ip.eql? zk
    Chef::Log.info "Found matching IP address in the list of zkd nodes: #{zk}. ID= #{id}"
    found_id = id
  end
  id += 1

end
Chef::Log.info "Found ID IS: #{found_id}"
if found_id == -1
  raise "Could not find matching IP address #{my_ip} in the list of zkd nodes: " + node['kzookeeper']['default']['private_ips'].join(",")
end

template "#{node['kzookeeper']['data_dir']}/myid" do
  source 'zookeeper.id.erb'
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  action :create
  mode '0755'
  variables({ :id => found_id })
  notifies :restart, "service[#{service_name}]", :delayed
end

template "#{node['kzookeeper']['home']}/bin/zkConnect.sh" do
  source 'zkClient.sh.erb'
  owner node['kzookeeper']['user']
  group node['kzookeeper']['group']
  action :create
  mode '0755'
  variables({ :servers => node['kzookeeper']['servers']})
  notifies :restart, "service[#{service_name}]", :delayed
end

kagent_config service_name do
  service "kafka"
  log_file "#{node['kzookeeper']['base_dir']}/zookeeper.log"
  config_file "#{node['kzookeeper']['base_dir']}/conf/zoo.cfg"
end

kagent_config "#{service_name}" do
  action :systemd_reload
end

# Register ZooKeeper with Consul
consul_service "Registering ZooKeeper with Consul" do
  service_definition "consul/zk-consul.hcl.erb"
  template_variables({
    :id => found_id
  })
  action :register
end

# Wait until node was joined the cluster. The "zkServer.sh status" command exits with "1" if the node is not
# connected to the cluster, otherwise it exits with "0"
bash 'check_node_status' do
  user "root"
  group "root"
  timeout 240
  code <<-EOH
       until #{node['kzookeeper']['install_dir']}/zookeeper/bin/zkServer.sh status; do sleep 1; done
  EOH
end
