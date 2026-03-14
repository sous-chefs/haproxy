# frozen_string_literal: true

name              'haproxy'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides haproxy_install, haproxy_service, haproxy_config_global, haproxy_config_defaults, haproxy_frontend, haproxy_backend, and haproxy_listen resources'
version           '12.4.12'
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
