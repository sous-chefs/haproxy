# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '2.8.13'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum '13dc06a65b7705b94c843bda8b845edbb621bf45e8a9dc7db590d40ab920a9ce'
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
