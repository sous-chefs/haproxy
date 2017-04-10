property :name, String, name_property: true
property :bind, String, default: '0.0.0.0:80'
property :maxconn, Integer, default: 2000
property :http_request, String
property :http_response, String
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :default_backend, String

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    template config_file do
      source 'haproxy.cfg.erb'
      cookbook 'haproxy'
      variables['frontend'] ||= {}
      variables['frontend'][new_resource.name] ||= {}
      variables['frontend'][new_resource.name]['bind'] ||= ''
      variables['frontend'][new_resource.name]['bind'] << new_resource.bind
      variables['frontend'][new_resource.name]['maxconn'] ||= ''
      variables['frontend'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s
      variables['frontend'][new_resource.name]['http_request'] ||= '' unless new_resource.http_request.nil?
      variables['frontend'][new_resource.name]['http_request'] << new_resource.http_request unless new_resource.http_request.nil?
      variables['frontend'][new_resource.name]['http_response'] ||= '' unless new_resource.http_response.nil?
      variables['frontend'][new_resource.name]['http_response'] << new_resource.http_response unless new_resource.http_response.nil?
      variables['frontend'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
      variables['frontend'][new_resource.name]['default_backend'] << new_resource.default_backend

      action :nothing
      delayed_action :create
    end
  end
end
