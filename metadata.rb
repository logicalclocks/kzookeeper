maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
name             "kzookeeper"
license          "Apache v2.0"
description      'Installs/Configures/Runs kzookeeper'
version          "0.1.1"

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

depends 'kagent'
depends 'java'

recipe            "kzookeeper::install", "Installs kzookeeper binaries"
recipe            "kzookeeper::default",  "configures zookeeper"
recipe            "kzookeeper::purge",  "Remove and delete zookeeper"


attribute "java/jdk_version",
          :description =>  "Jdk version",
          :type => 'string'

attribute "java/install_flavor",
          :description =>  "Oracle (default) or openjdk",
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


