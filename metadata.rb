name             'kzookeeper'
maintainer       "zookeeper"
maintainer_email "jdowling@kth.se"
license          "Apache v2.0"
description      'Installs/Configures/Runs kzookeeper'
version          "0.1"

recipe            "kzookeeper::install", "Experiment setup for kzookeeper"


depends 'zookeeper'
depends 'java'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "kzookeeper/version",
:description => "Version of kzookeeper",
:type => 'string',
:default => "0.1"


attribute "kzookeeper/url",
:description => "Url to download binaries for kzookeeper",
:type => 'string',
:default => ""

attribute "kzookeeper/user",
:description => "Run kzookeeper as this user",
:type => 'string',
:default => "kzookeeper"


