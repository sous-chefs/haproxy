# frozen_string_literal: true
haproxy_config_global '' do
end

haproxy_config_defaults '' do
end

haproxy_install 'source' do
  source_url 'http://ps-cf.rightscale.com/haproxy/haproxy-1.7.5.tar.gz'
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
end
