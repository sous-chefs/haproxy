name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures haproxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '6.3.0'
source_url        'https://github.com/sous-chefs/haproxy'
issues_url        'https://github.com/sous-chefs/haproxy/issues'
chef_version      '>= 13.0'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'amazon'
supports 'opensuseleap'

depends 'build-essential', '>= 8.0.1'
depends 'poise-service',   '>= 1.5.1'
