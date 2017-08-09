# This recipe is for an example only,
# it is not supported in a runlist.
# It will only create a blank useless configuration
haproxy_install 'package' do
  action :create
end

haproxy_config_defaults 'default' do
  action :create
end

haproxy_config_global 'default' do
  action :create
end

haproxy_frontend 'default' do
  action :create
end

haproxy_backend 'default' do
  action :create
end
