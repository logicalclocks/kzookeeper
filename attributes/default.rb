include_attribute "kagent"

default['kzookeeper']['version']                   = '3.7.1'
default['kzookeeper']['user']                      = node['install']['user'].empty? ? "zookeeper" : node['install']['user']
default['kzookeeper']['user_id']                   = '1520'
default['kzookeeper']['group']                     = node['install']['user'].empty? ? "zookeeper" : node['install']['user']
default['kzookeeper']['group_id']                  = '1515'


default['kzookeeper']['dir']                       = node['install']['dir'].empty? ? "/opt" : node['install']['dir']
default['kzookeeper']['install_dir']               = "#{node['kzookeeper']['dir']}/zookeeper"
default['kzookeeper']['base_dir']                  = "#{node['kzookeeper']['install_dir']}/zookeeper"
default['kzookeeper']['home']                      = "#{node['kzookeeper']['install_dir']}/zookeeper-#{node['kzookeeper']['version']}"
default['kzookeeper']['bin_dir']                   = "#{node['kzookeeper']['base_dir']}/bin"
default['kzookeeper']['data_dir']                  = "#{node['kzookeeper']['base_dir']}/data"
default['kzookeeper']['conf_dir']                  = "#{node['kzookeeper']['base_dir']}/conf"

default['kzookeeper']['data_volume']['root_dir']   = "#{node['data']['dir']}/zookeeper"
default['kzookeeper']['data_volume']['data_dir']   = "#{node['kzookeeper']['data_volume']['root_dir']}/data"

default['kzookeeper']['download_url']              = "#{node['download_url']}/apache-zookeeper-#{node['kzookeeper']['version']}-bin.tar.gz"
default['kzookeeper']['checksum']                  = '919936185857283ee73445695a9d4921bc9d6e5e03d97839b78ec0082513d7b9'

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