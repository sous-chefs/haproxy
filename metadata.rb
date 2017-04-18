# frozen_string_literal: true
name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache 2.0'
description       'Installs and configures haproxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '4.0.0'
source_url        'https://github.com/sous-chefs/haproxy'
issues_url        'https://github.com/sous-chefs/haproxy/issues'
chef_version      '>= 12.5' if respond_to?(:chef_version)

%w( debian ubuntu centos redhat scientific oracle ).each do |os|
  supports os
end

depends           'cpu', '>= 0.2.0'
depends           'build-essential'
depends           'poise-service'
