apt_update

haproxy_install 'source' do
  source_url 'http://www.haproxy.org/download/2.2/src/haproxy-2.2.14.tar.gz'
  source_checksum '6a9b702f04b07786f3e5878de8172a727acfdfdbc1cefe1c7a438df372f2fb61'
  source_version '2.2.14'
  use_libcrypt true
  use_pcre true
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy' do
  action :create
  delayed_action %i(enable start)
end
