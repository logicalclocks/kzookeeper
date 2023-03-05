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
default['kzookeeper']['data_dir']                  = "#{node['kzookeeper']['base_dir']}/data"
default['kzookeeper']['conf_dir']                  = "#{node['kzookeeper']['base_dir']}/conf"

default['kzookeeper']['data_volume']['root_dir']   = "#{node['data']['dir']}/zookeeper"
default['kzookeeper']['data_volume']['data_dir']   = "#{node['kzookeeper']['data_volume']['root_dir']}/data"

default['kzookeeper']['checksum']                  = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default['kzookeeper']['mirror']                    = node['download_url']

# This attribute is here so that it can be parsed by setup-chef. The download url is re-built by the default provider
default['kzookeeper']['download_url']              = ::File.join(node['download_url'], "zookeeper-#{node['kzookeeper']['version']}", "zookeeper-#{node['kzookeeper']['version']}.tar.gz")

default['kzookeeper']['use_java_cookbook']         = true

default['kzookeeper']['config'] = {
  clientPort: 2181,
  dataDir: "#{node['kzookeeper']['home']}/data", 
  tickTime: 2000,
  syncLimit: 3,
  initLimit: 60,
  # unlimited number of IO connections, this might be set to a reasonable number
  maxClientCnxns: 0,
  autopurge: {
    snapRetainCount: 1,
    purgeInterval: 1
  },
  "authProvider.1": "org.apache.zookeeper.server.auth.SASLAuthenticationProvider"
}

default['kzookeeper']['pid_file']                  = "#{node['kzookeeper']['base_dir']}/data/zookeeper_server.pid"

# Username/password authentication to setup ACLs
# Currently using JAAS to authenticate clients, will switch to mTLS 
# once we upgrade Kafka/Zookeeper

default['kzookeeper']['superuser']['username']     = "super"
default['kzookeeper']['superuser']['password']     = "adminpw"

default['kzookeeper']['kafka']['username']     = "kafka"
default['kzookeeper']['kafka']['password']     = "adminpw"