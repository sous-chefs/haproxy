# frozen_string_literal: true
haproxy_install 'source'

haproxy_config_global '' do
end

haproxy_config_defaults '' do
end

haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
end
