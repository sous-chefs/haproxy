property :timeout, Hash, default: { client: '10s', server: '10s', connect: '10s' }
property :name, String, name_property: true
property :log, String, default: 'global'
property :mode, String, default: 'http', equal_to: %w(http tcp)
property :balance, default: 'roundrobin', equal_to: %w(roundrobin static-rr leastconn first source uri url_param header rdp-cookie)
property :option, Array, default: %w(httplog dontlognull redispatch)
property :status_uri, String, default: '/haproxy-status'
property :status_user, String, default: 'stats'
property :status_password, String, default: 'stats'
property :maxconn, Integer
property :http_check_disable_on_404, [TrueClass, FalseClass, nil], default: true
property :http_check_expect, [String, nil]
property :http_check_send_state, [TrueClass, FalseClass, nil]
property :http_request, [String, nil]
property :http_response, [String, nil]
property :http_reuse, [String, nil], equal_to: %w(never safe aggressive always)
property :http_send_name_header, [String, nil]
property :options, Hash
property :haproxy_retries, Integer
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    template config_file do
      source 'haproxy.cfg.erb'
      cookbook 'haproxy'
      variables['defaults'] ||= {}
      variables['defaults']['timeouts'] ||= {}
      variables['defaults']['timeouts'] = new_resource.timeout unless new_resource.timeout.nil?
      variables['defaults']['log'] ||= ''
      variables['defaults']['log'] << new_resource.log
      variables['defaults']['mode'] ||= ''
      variables['defaults']['mode'] << new_resource.mode
      variables['defaults']['balance'] ||= '' unless new_resource.balance.nil?
      variables['defaults']['balance'] << new_resource.balance unless new_resource.balance.nil?
      variables['defaults']['option'] ||= []
      variables['defaults']['option'] << new_resource.option
      variables['defaults']['status_uri'] ||= ''
      variables['defaults']['status_uri'] << new_resource.status_uri
      variables['defaults']['status_user'] ||= ''
      variables['defaults']['status_user'] << new_resource.status_user
      variables['defaults']['status_password'] ||= ''
      variables['defaults']['status_password'] << new_resource.status_password
      variables['defaults']['maxconn'] ||= '' unless new_resource.maxconn.nil?
      variables['defaults']['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
      variables['defaults']['retries'] ||= '' unless new_resource.retries.nil?
      variables['defaults']['retries'] << new_resource.retries.to_s unless new_resource.retries.nil?
      variables['defaults']['http_check_disable_on_404'] ||= ''
      variables['defaults']['http_check_disable_on_404'] << new_resource.http_check_disable_on_404.to_s
      variables['defaults']['http_check_expect'] ||= '' unless new_resource.http_check_expect.nil?
      variables['defaults']['http_check_expect'] << new_resource.http_check_expect unless new_resource.http_check_expect.nil?
      variables['defaults']['http_check_send_state'] ||= ''
      variables['defaults']['http_check_send_state'] << new_resource.http_check_send_state.to_s
      variables['defaults']['http_request'] ||= '' unless new_resource.http_request.nil?
      variables['defaults']['http_request'] << new_resource.http_request unless new_resource.http_request.nil?
      variables['defaults']['http_response'] ||= '' unless new_resource.http_response.nil?
      variables['defaults']['http_response'] << new_resource.http_response unless new_resource.http_response.nil?
      variables['defaults']['http_reuse'] ||= '' unless new_resource.http_reuse.nil?
      variables['defaults']['http_reuse'] << new_resource.http_reuse unless new_resource.http_reuse.nil?
      variables['defaults']['http_send_name_header'] ||= '' unless new_resource.http_send_name_header.nil?
      variables['defaults']['http_send_name_header'] << new_resource.http_send_name_header unless new_resource.http_send_name_header.nil?
      variables['defaults']['options'] ||= {} unless new_resource.options.nil?
      variables['defaults']['options'] = new_resource.options unless new_resource.options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
