name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache 2.0'
description       'Installs and configures haproxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '3.0.1'
source_url        'https://github.com/sous-chefs/haproxy' if respond_to?(:source_url)
issues_url        'https://github.com/sous-chefs/haproxy/issues' if respond_to?(:issues_url)
chef_version      '>= 12.1' if respond_to?(:chef_version)

%w( debian ubuntu centos redhat scientific oracle ).each do |os|
  supports os
end

depends           'compat_resource', '>= 12.16.3'
depends           'cpu', '>= 0.2.0'
depends           'build-essential'
depends           'poise-service'
