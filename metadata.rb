# frozen_string_literal: true

name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures haproxy'
version           '12.4.13'
source_url        'https://github.com/sous-chefs/haproxy'
issues_url        'https://github.com/sous-chefs/haproxy/issues'
chef_version      '>= 16'

supports 'almalinux'
supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'opensuseleap'
supports 'oracle'
supports 'redhat'
supports 'rocky'
supports 'ubuntu'

depends 'yum-epel'
