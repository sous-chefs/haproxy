haproxy_config_global '' do

end

haproxy_config_defaults '' do
end

haproxy_install 'source' do
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end
