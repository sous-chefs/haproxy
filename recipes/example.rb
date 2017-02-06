# This recipe is for an example only,
# it is not supported in a runlist.

haproxy 'default' do
  action :create
end

haproxy_config_defaults 'default' do
  action :create
end

haproxy_config_global 'default' do
  action :create
end

haproxy_config_frontend 'default' do
  action :create
end

haproxy_config_backend 'default' do
  action :create
end

haproxy 'default' do
  action :restart
end
