property :mode, String, equal_to: %w(http tcp)
property :bind, [String, Hash], default: '0.0.0.0:80'
property :maxconn, Integer
property :stats, Hash
property :http_request, [Array, String]
property :http_response, String
property :reqrep, [Array, String]
property :reqirep, [Array, String]
property :default_backend, String
property :use_backend, Array
property :acl, Array
property :extra_options, Hash
property :server, Array
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :hash_type, String, equal_to: %w(consistent map-based)

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
      variables['listen'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
      variables['listen'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
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
      variables['listen'][new_resource.name]['maxconn'] ||= '' unless new_resource.maxconn.nil?
      variables['listen'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
      variables['listen'][new_resource.name]['stats'] ||= {} unless new_resource.stats.nil?
      variables['listen'][new_resource.name]['stats'].merge!(new_resource.stats) unless new_resource.stats.nil?
      variables['listen'][new_resource.name]['http_request'] = [new_resource.http_request].flatten unless new_resource.http_request.nil?
      variables['listen'][new_resource.name]['http_response'] ||= '' unless new_resource.http_response.nil?
      variables['listen'][new_resource.name]['http_response'] << new_resource.http_response unless new_resource.http_response.nil?
      variables['listen'][new_resource.name]['reqrep'] = [new_resource.reqrep].flatten unless new_resource.reqrep.nil?
      variables['listen'][new_resource.name]['reqirep'] = [new_resource.reqirep].flatten unless new_resource.reqirep.nil?
      variables['listen'][new_resource.name]['use_backend'] ||= [] unless new_resource.use_backend.nil?
      variables['listen'][new_resource.name]['use_backend'] << new_resource.use_backend unless new_resource.use_backend.nil?
      variables['listen'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
      variables['listen'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
      variables['listen'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
      variables['listen'][new_resource.name]['default_backend'] << new_resource.default_backend unless new_resource.default_backend.nil?
      variables['listen'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
      variables['listen'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
      variables['listen'][new_resource.name]['hash_type'] = new_resource.hash_type unless new_resource.hash_type.nil?
      variables['listen'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['listen'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
