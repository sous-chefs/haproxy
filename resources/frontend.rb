property :bind, [String, Hash], default: '0.0.0.0:80'
property :mode, String, equal_to: %w(http tcp)
property :maxconn, Integer, default: 2000
property :default_backend, String
property :use_backend, Array
property :acl, Array
property :option, Array
property :stats, Hash, default: {}
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
      variables['frontend'] ||= {}
      variables['frontend'][new_resource.name] ||= {}
      variables['frontend'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
      variables['frontend'][new_resource.name]['default_backend'] << new_resource.default_backend unless new_resource.default_backend.nil?
      variables['frontend'][new_resource.name]['bind'] = []
      if new_resource.bind.is_a? Hash
        new_resource.bind.map do |addresses, ports|
          (Array(addresses).product Array(ports)).each do |combo|
            variables['frontend'][new_resource.name]['bind'] << combo.join(':')
          end
        end
      else
        variables['frontend'][new_resource.name]['bind'] << new_resource.bind
      end
      variables['frontend'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
      variables['frontend'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
      variables['frontend'][new_resource.name]['stats'] ||= {}
      variables['frontend'][new_resource.name]['stats'].merge!(new_resource.stats)

      variables['frontend'][new_resource.name]['maxconn'] ||= ''
      variables['frontend'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s
      variables['frontend'][new_resource.name]['use_backend'] ||= [] unless new_resource.use_backend.nil?
      variables['frontend'][new_resource.name]['use_backend'] << new_resource.use_backend unless new_resource.use_backend.nil?
      variables['frontend'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
      variables['frontend'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
      variables['frontend'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
      variables['frontend'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
      variables['frontend'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['frontend'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
