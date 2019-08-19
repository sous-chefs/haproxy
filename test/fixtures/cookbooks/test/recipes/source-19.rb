# frozen_string_literal: true
apt_update

haproxy_install 'source' do
  source_url 'https://www.haproxy.org/download/1.9/src/haproxy-1.9.8.tar.gz'
  source_checksum '2d9a3300dbd871bc35b743a83caaf50fecfbf06290610231ca2d334fd04c2aee'
  source_version '1.9.8'
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
