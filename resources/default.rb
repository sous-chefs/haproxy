provides :haproxy

property :name, String, default: 'default', name_property: true
property :install_type, String, default: 'package'

action :create do
  include_recipe "haproxy::install_#{install_type}"

  case install_type
  when 'package'
  when 'source'
  end

  poise_service 'haproxy' do
    provider node['init_package']
    command "#{haproxy_systemd_wrapper} -f #{haproxy_config_file} -p /run/haproxy.pid $OPTIONS"
    options node['haproxy']['poise_service']['options'][node['init_package']]
    action :enable
  end
end

action :start do
  poise_service 'haproxy' do
    action :start
  end
end

action :stop do
  poise_service 'haproxy' do
    action :stop
  end
end

action :restart do
  poise_service 'haproxy' do
    action :restart
  end
end

action :reload do
  poise_service 'haproxy' do
    action :reload
  end
end
