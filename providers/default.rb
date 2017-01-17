use_inline_resources

def whyrun_supported?
  true
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

def load_current_resource
  unless new_resource.config_directory
    case node['haproxy']['install_method']
    when 'package'
      new_resource.config_directory node['haproxy']['conf_dir']
    when 'source'
      new_resource.config_directory ::File.join(node['haproxy']['source']['prefix'], node['haproxy']['conf_dir'])
    end
  end
end

def make_hash(attr)
  new_hash = {}
  attr.each do |k, v|
    new_hash[k] = if v.is_a?(Hash)
                    make_hash(v)
                  else
                    v
                  end
  end
  new_hash
end

def create_haproxy_etc_directory
  directory new_resource.config_directory do
    recursive true
  end
end

def haproxy_default_file
  cookbook_file '/etc/default/haproxy' do
    source 'haproxy-default'
    cookbook 'haproxy'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[haproxy]', :delayed
  end
end

def create_haproxy_cfg
  template ::File.join(new_resource.config_directory, 'haproxy.cfg') do
    source 'haproxy.dynamic.cfg.erb'
    cookbook 'haproxy'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :reload, 'service[haproxy]', :delayed
    variables(config: new_resource.config)
  end
end

def create_poise_service
  poise_service_user node['haproxy']['user'] do
    home '/home/haproxy'
    group node['haproxy']['group']
    action :create
  end

  node.override['haproxy']['conf_dir'] = ::File.join(node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/', 'etc', 'haproxy')
  node.override['haproxy']['global_prefix'] = node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/usr'
  if node['init_package'] == 'systemd'
    haproxy_systemd_wrapper = ::File.join(node['haproxy']['global_prefix'], 'sbin', 'haproxy-systemd-wrapper')
    haproxy_config_file = ::File.join(node['haproxy']['conf_dir'], 'haproxy.cfg')
    poise_service 'haproxy' do
      user node['haproxy']['user']
      provider :systemd
      command "#{haproxy_systemd_wrapper} -f #{haproxy_config_file} -p /run/haproxy.pid $OPTIONS"
      options node['haproxy']['poise_service']['options']['systemd']
      action [ :enable, :start ]
    end
  else
    haproxy_command = ::File.join(node['haproxy']['global_prefix'], 'sbin', 'haproxy')
    haproxy_config_file = ::File.join(node['haproxy']['conf_dir'], 'haproxy.cfg')
    poise_service 'haproxy' do
      user node['haproxy']['user']
      provider :sysvinit
      command "#{haproxy_command} -f #{haproxy_config_file}"
      options node['haproxy']['poise_service']['options']['sysvinit']
      action [ :enable, :start ]
    end
  end
end

action :create do
  node.override['haproxy']['conf_dir'] = new_resource.config_directory
  run_context.include_recipe "haproxy::install_#{node['haproxy']['install_method']}"

  if new_resource.config.is_a?(Proc)
    chef_gem 'attribute_struct'
    require 'attribute_struct'
    new_resource.config AttributeStruct.new(&new_resource.config)._dump
  end

  set_updated { create_haproxy_etc_directory }

  new_resource.config Chef::Mixin::DeepMerge.merge(make_hash(node['haproxy']['config']), new_resource.config)

  set_updated { haproxy_default_file }

  set_updated { create_haproxy_cfg }

  set_updated { create_poise_service }

end

action :delete do
  file ::File.join(new_resource.config_directory, 'haproxy.cfg') do
    action :delete
  end

  poise_service 'haproxy' do
    action :stop
  end
end
