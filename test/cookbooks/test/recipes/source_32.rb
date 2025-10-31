# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '3.2.7'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum '1f0ae9dfb0b319e2d5cb6e4cdf931a0877ad88e0090c46cf16faf008fbf54278'
  source_version version
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
