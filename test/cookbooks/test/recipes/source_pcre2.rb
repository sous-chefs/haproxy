apt_update

# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '3.2.14'

# Test recipe for RHEL/CentOS platforms version 10 and above (uses PCRE2)
haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum 'b21f50a790aa8cb0cf8dc505f1f8d849799eafe4d31c14b86a34409ccf4ae5e4'
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
