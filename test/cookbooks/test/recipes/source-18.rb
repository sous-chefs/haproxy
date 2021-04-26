apt_update

haproxy_install 'source' do
  source_url 'http://www.haproxy.org/download/1.8/src/haproxy-1.8.17.tar.gz'
  source_checksum '7b789b177875afdd5ddeff058e7efde73aa895dc2dcf728b464358635ae3948e'
  source_version '1.8.17'
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
  action %i(create enable start)
end
