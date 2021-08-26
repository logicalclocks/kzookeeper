include_attribute "kagent"

default['kzookeeper']['version']                   = '3.4.7'
default['kzookeeper']['url']                       = ""
default['kzookeeper']['user']                      = node['install']['user'].empty? ? "zookeeper" : node['install']['user']
default['kzookeeper']['user_id']                   = '1520'
default['kzookeeper']['group']                     = node['install']['user'].empty? ? "zookeeper" : node['install']['user']
default['kzookeeper']['group_id']                  = '1515'


default['kzookeeper']['dir']                       = node['install']['dir'].empty? ? "/opt" : node['install']['dir']
default['kzookeeper']['install_dir']               = "#{node['kzookeeper']['dir']}/zookeeper"
default['kzookeeper']['base_dir']                  = "#{node['kzookeeper']['install_dir']}/zookeeper"
default['kzookeeper']['home']                      = "#{node['kzookeeper']['install_dir']}/zookeeper-#{node['kzookeeper']['version']}"


default['kzookeeper']['default']['private_ips'] = ['10.0.2.15']


default['kzookeeper']['checksum']                  = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default['kzookeeper']['mirror']                    = node['download_url']

# This attribute is here so that it can be parsed by setup-chef. The download url is re-built by the default provider
default['kzookeeper']['download_url']              = ::File.join(node['download_url'], "zookeeper-#{node['kzookeeper']['version']}", "zookeeper-#{node['kzookeeper']['version']}.tar.gz")

default['kzookeeper']['use_java_cookbook']         = true

default['kzookeeper']['config'] = {
  clientPort: 2181,
  dataDir: "#{node['kzookeeper']['home']}/data", 
  tickTime: 2000
}


default['kzookeeper']['pid_file']                  = "#{node['kzookeeper']['base_dir']}/data/zookeeper_server.pid"



