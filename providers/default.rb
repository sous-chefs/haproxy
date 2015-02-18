use_inline_resources if respond_to?(:use_inline_resources)

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
  attr.each do |k,v|
    if(v.is_a?(Hash))
      new_hash[k] = make_hash(v)
    else
      new_hash[k] = v
    end
  end
  new_hash
end

action :create do

  run_context.include_recipe "haproxy::install_#{node['haproxy']['install_method']}"

  if(new_resource.config.is_a?(Proc))
    chef_gem 'attribute_struct' do
      compile_time true
      action :install
    end
    require 'attribute_struct'
    new_resource.config AttributeStruct.new(&new_resource.config)._dump
  end

  directory new_resource.config_directory do
    recursive true
  end

  new_resource.config Chef::Mixin::DeepMerge.merge(make_hash(node[:haproxy][:config]), new_resource.config)

  cookbook_file '/etc/default/haproxy' do
    source 'haproxy-default'
    cookbook 'haproxy'
    owner 'root'
    group 'root'
    mode 00644
    notifies :restart, 'service[haproxy]'
  end

  template ::File.join(new_resource.config_directory, 'haproxy.cfg') do
    source 'haproxy.dynamic.cfg.erb'
    cookbook 'haproxy'
    owner 'root'
    group 'root'
    mode 00644
    notifies :reload, 'service[haproxy]'
    variables(:config => new_resource.config)
  end

  service "haproxy" do
    supports :restart => true, :status => true, :reload => true
    action [:enable, :start]
  end

end

action :delete do
  file ::File.join(new_resource.config_directory, 'haproxy.cfg') do
    action :delete
  end

  service 'haproxy' do
    action :stop
  end
end
