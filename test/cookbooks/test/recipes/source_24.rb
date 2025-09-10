# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '2.4.25'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum '44b035bdc9ffd4935f5292c2dfd4a1596c048dc59c5b25a0c6d7689d64f50b99'
  source_version version
  use_libcrypt true
  use_pcre true
  use_openssl true
  use_zlib true
  use_promex true
  use_linux_tproxy true
  use_linux_splice true
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy' do
  action :create
  delayed_action %i(enable start)
end
