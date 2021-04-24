apt_update

haproxy_install 'source' do
  source_url 'https://www.haproxy.org/download/2.0/src/haproxy-2.0.12.tar.gz'
  source_checksum '7fcf5adb21cd78c4161902f9fcc8d7fc97e1562319a992cbda884436ca9602fd'
  source_version '2.0.12'
  use_libcrypt '1'
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy' do
  action :create
  delayed_action %i(enable start)
end
