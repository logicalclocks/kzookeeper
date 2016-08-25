include_attribute "kagent"

default.kzookeeper.version                   = '3.4.7'
default.kzookeeper.url                       = ""
default.kzookeeper.user                      = "zookeeper"
default.kzookeeper.group                     = "zookeeper"

default.kzookeeper.install_dir               = '/opt/zookeeper'


default[:kzookeeper][:default][:private_ips] = ['10.0.2.15']


default.kzookeeper.checksum                  = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default.kzookeeper.mirror                    = node.download_url

default.kzookeeper.use_java_cookbook         = true

default.kzookeeper.config = {
  clientPort: 2181,
  dataDir: '/var/lib/zookeeper',
  tickTime: 2000
}

default.kzookeeper.base_dir                  = "#{node.kzookeeper.install_dir}/zookeeper"

default.kzookeeper.home                      = "#{node.kzookeeper.install_dir}/zookeeper-#{node.kzookeeper.version}"

default.kzookeeper.pid_file                  = "#{node.kzookeeper.base_dir}/data/zookeeper_server.pid"



