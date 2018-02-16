property :mode, String, default: 'http', equal_to: %w(http tcp)
property :bind, [String, Hash], default: '0.0.0.0:80'
property :maxconn, Integer, default: 2000
property :stats, Hash
property :http_request, String
property :http_response, String
property :default_backend, String
property :use_backend, Array
property :acl, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['listen'] ||= {}
      variables['listen'][new_resource.name] ||= {}
      variables['listen'][new_resource.name]['mode'] ||= ''
      variables['listen'][new_resource.name]['mode'] << new_resource.mode
      variables['listen'][new_resource.name]['bind'] ||= []
      if new_resource.bind.is_a? Hash
        new_resource.bind.map do |addresses, ports|
          (Array(addresses).product Array(ports)).each do |combo|
            variables['listen'][new_resource.name]['bind'] << combo.join(':')
          end
        end
      else
        variables['listen'][new_resource.name]['bind'] << new_resource.bind
      end
      variables['listen'][new_resource.name]['maxconn'] ||= ''
      variables['listen'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s
      variables['listen'][new_resource.name]['stats'] ||= {} unless new_resource.stats.nil?
      variables['listen'][new_resource.name]['stats'].merge!(new_resource.stats) unless new_resource.stats.nil?
      variables['listen'][new_resource.name]['http_request'] ||= '' unless new_resource.http_request.nil?
      variables['listen'][new_resource.name]['http_request'] << new_resource.http_request unless new_resource.http_request.nil?
      variables['listen'][new_resource.name]['http_response'] ||= '' unless new_resource.http_response.nil?
      variables['listen'][new_resource.name]['http_response'] << new_resource.http_response unless new_resource.http_response.nil?
      variables['listen'][new_resource.name]['use_backend'] ||= [] unless new_resource.use_backend.nil?
      variables['listen'][new_resource.name]['use_backend'] << new_resource.use_backend unless new_resource.use_backend.nil?
      variables['listen'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
      variables['listen'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
      variables['listen'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
      variables['listen'][new_resource.name]['default_backend'] << new_resource.default_backend unless new_resource.default_backend.nil?
      variables['listen'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['listen'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
