name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures haproxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '4.5.0'
source_url        'https://github.com/sous-chefs/haproxy'
issues_url        'https://github.com/sous-chefs/haproxy/issues'
chef_version      '>= 12.5' if respond_to?(:chef_version)

%w( debian ubuntu centos redhat oracle amazon ).each do |os|
  supports os
end

depends           'cpu', '>= 0.2.0'
depends           'build-essential', '>= 8.0.1'
depends           'poise-service',   '>= 1.5.1'
depends           'compat_resource', '>= 12.16'
