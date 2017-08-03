# frozen_string_literal: true
haproxy_config_global '' do
end

haproxy_config_defaults '' do
end

haproxy_install 'source' do
  source_url node['haproxy']['source_url']
  source_checksum node['haproxy']['source_checksum']
  source_version node['haproxy']['source_version']
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end
