# frozen_string_literal: true
apt_update

haproxy_install 'source' do
  source_url 'https://www.haproxy.org/download/2.2/src/haproxy-2.2.4.tar.gz'
  source_checksum '87a4d9d4ff8dc3094cb61bbed4a8eed2c40b5ac47b9604daebaf036d7b541be2'
  source_version '2.2.4'
  use_libcrypt '1'
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy'
