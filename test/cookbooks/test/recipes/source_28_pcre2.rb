version = '2.8.5'

# Test recipe for RHEL/CentOS platforms version 10 and above (uses PCRE2)
haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum '3f5459c5a58e0b343a32eaef7ed5bed9d3fc29d8aa9e14b36c92c969fc2a60d9'
  source_version version
  # Rely on auto-detection for PCRE2 on RHEL >= 10
  use_libcrypt true
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
