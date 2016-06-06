#include_attribute "zookeeper"

default.kzookeeper.version                   = '3.4.7'
default.kzookeeper.url                       = ""
#default.kzookeeper.version                  = "0.1"
#default.kzookeeper.user                     = "zookeeper"
default.kzookeeper.group                     = "zookeeper"

default.kzookeeper.version_dir               = "/usr/local/kzookeeper-#{node.kzookeeper.version}"
default.kzookeeper.home_dir                  = "/usr/local/kzookeeper"

default[:kzookeeper][:default][:private_ips] = ['10.0.2.15']


default.kzookeeper.checksum                  = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default.kzookeeper.mirror                    = 'http://snurran.sics.se/hops/'
default.kzookeeper.user                      = 'zookeeper'
default.kzookeeper.install_dir               = '/opt/zookeeper'
default.kzookeeper.use_java_cookbook         = true

# One of 'upstart', 'runit', 'exhibitor'
#default.zookeeper.service_style = 'systemd'

default.kzookeeper.config = {
  clientPort: 2181,
  dataDir: '/var/lib/zookeeper',
  tickTime: 2000
}

default.kzookeeper.base_dir                 = "#{node.kzookeeper.install_dir}/zookeeper-#{node.kzookeeper.version}"

node.default.java.jdk_version               = "7"


