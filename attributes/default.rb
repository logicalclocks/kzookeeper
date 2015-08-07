default[:kzookeeper][:url] = ""
default[:kzookeeper][:version] = "0.1"
default[:kzookeeper][:user] = "zookeeper"
default[:kzookeeper][:group] = "zookeeper"

default[:kzookeeper][:version_dir] = "/usr/local/kzookeeper-#{node[:kzookeeper][:version]}"
default[:kzookeeper][:home_dir] = "/usr/local/kzookeeper"

default[:zookeeper][:base_dir] = "#{node[:zookeeper][:install_dir]}/zookeeper-#{node[:zookeeper][:version]}"
