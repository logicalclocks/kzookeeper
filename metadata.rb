maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
name             "kzookeeper"
license          "Apache v2.0"
description      'Installs/Configures/Runs kzookeeper'
version          "3.1.0"

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end


depends 'kagent'
depends 'consul'
depends 'java'


recipe            "kzookeeper::install", "Installs kzookeeper binaries"
recipe            "kzookeeper::default",  "configures zookeeper"
recipe            "kzookeeper::purge",  "Remove and delete zookeeper"

attribute "kzookeeper/version",
          :description => "Version of kzookeeper",
          :type => 'string'

attribute "kzookeeper/url",
          :description => "Url to download binaries for kzookeeper",
          :type => 'string'

attribute "kzookeeper/user",
          :description => "Run kzookeeper as this user",
          :type => 'string'

attribute "kzookeeper/user_id",
          :description => "zookeeper user id",
          :type => 'string'

attribute "kzookeeper/group",
          :description => "Run kzookeeper user as this group",
          :type => 'string'

attribute "kzookeeper/group_id",
          :description => "zookeeper group id",
          :type => 'string'

attribute "kzookeeper/dir",
          :description => "Base directory to install zookeeper (default: /opt)",
          :type => 'string'

attribute "kzookeeper/default/private_ips",
          :description => "Set ip addresses",
          :type => "array"

attribute "kzookeeper/default/public_ips",
          :description => "Set ip addresses",
          :type => "array"

attribute "kzookeeper/superuser/username",
          :description => "Jaas superuser username to authenticate with zookeeper (default: super)",
          :type => "string"

attribute "kzookeeper/superuser/password",
          :description => "Jaas superuser password to authenticate with zookeeper (default: adminpw)",
          :type => "string"

attribute "kzookeeper/kafka/username",
          :description => "Jaas kafka username to authenticate with zookeeper (default: kafka)",
          :type => "string"

attribute "kzookeeper/kafka/password",
          :description => "Jaas kafka password to authenticate with zookeeper (default: adminpw)",
          :type => "string"