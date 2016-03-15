#include_attribute "zookeeper"

default.kzookeeper.url = ""
default.kzookeeper.version = "0.1"
default.kzookeeper.user = "zookeeper"
default.kzookeeper.group = "zookeeper"

default.kzookeeper.version_dir = "/usr/local/kzookeeper-#{node.kzookeeper.version}"
default.kzookeeper.home_dir = "/usr/local/kzookeeper"

default[:kzookeeper][:default][:private_ips] = ['10.0.2.15']

default.zookeeper.version     = '3.4.7'
default.zookeeper.checksum    = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default.zookeeper.mirror      = 'http://snurran.sics.se/hops/'
default.zookeeper.user        = 'zookeeper'
default.zookeeper.install_dir = '/opt/zookeeper'
default.zookeeper.use_java_cookbook = true

# One of 'upstart', 'runit', 'exhibitor'
#default.zookeeper.service_style = 'systemd'

default.zookeeper.config = {
  clientPort: 2181,
  dataDir: '/var/lib/zookeeper',
  tickTime: 2000
}

default.zookeeper.base_dir = "#{node.zookeeper.install_dir}/zookeeper-#{node.zookeeper.version}"

node.default.java.jdk_version     = 7


