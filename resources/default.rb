resource_name :haproxy

property :name, String, default: 'default', name_property: true
property :install_type, String, default: 'package', equal_to: %w(package source)

action :create do

  case install_type
  when 'package'
    package node['haproxy']['package']['name'] do
      version node['haproxy']['package']['version'] if node['haproxy']['package']['version']
      action :install
    end

    directory node['haproxy']['conf_dir'] do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end
    config_file='/etc/haproxy/haproxy.cfg'
    bin_prefix='/usr/sbin'
  when 'source'
    include_recipe 'haproxy::install_source'
    config_file='/usr/local/etc/haproxy/haproxy.cfg'
    bin_prefix='/usr/local/bin'
    node.override['haproxy']['poise_service']['options']['sysvinit']['conf_dir'] = '/usr/local/etc/haproxy'
  end
  if node['init_package'] == 'systemd'
    haproxy_command = "#{::File.join(bin_prefix, 'haproxy-systemd-wrapper')} -f #{config_file} -p /run/haproxy.pid $OPTIONS"
  else
    haproxy_command = ::File.join(bin_prefix, 'haproxy')
  end

  poise_service 'haproxy' do
    provider node['init_package']
    command haproxy_command
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
