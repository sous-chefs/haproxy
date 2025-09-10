# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '2.6.16'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum 'faac6f9564caf6e106fe22c77a1fb35406afc8cd484c35c2c844aaf0d7a097fb'
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
  action %i(create enable start)
end
