name             "kzookeeper"
maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache v2.0"
description      'Installs/Configures/Runs kzookeeper'
version          "0.1"

recipe            "kzookeeper::install", "Experiment setup for kzookeeper"
recipe            "kzookeeper::default",  "configFile=; default recipe to install zookeeper"
recipe            "kzookeeper::purge",  "Remove and delete zookeeper"

depends 'kagent'
depends 'java'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "java/jdk_version",
:display_name =>  "Jdk version",
:type => 'string'

attribute "kzookeeper/version",
:description => "Version of kzookeeper",
:type => 'string'

attribute "kzookeeper/url",
:description => "Url to download binaries for kzookeeper",
:type => 'string'

attribute "kzookeeper/user",
:description => "Run kzookeeper as this user",
:type => 'string'

attribute "kzookeeper/group",
:description => "Run kzookeeper user as this group",
:type => 'string'


