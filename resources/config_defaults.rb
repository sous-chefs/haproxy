property :timeout, Hash, default: { client: '10s', server: '10s', connect: '10s' }
property :log, String, default: 'global'
property :mode, String, default: 'http', equal_to: %w(http tcp)
property :balance, String, default: 'roundrobin', equal_to: %w(roundrobin static-rr leastconn first source uri url_param header rdp-cookie)
property :option, Array, default: %w(httplog dontlognull redispatch tcplog)
property :stats, Hash, default: { 'uri' => '/haproxy-status' }
property :maxconn, Integer
property :extra_options, Hash
property :haproxy_retries, Integer
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :hash_type, [String, nil], default: nil, equal_to: ['consistent', 'map-based', nil]

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['defaults'] ||= {}
      variables['defaults']['timeout'] ||= {}
      variables['defaults']['timeout'] = new_resource.timeout unless new_resource.timeout.nil?
      variables['defaults']['log'] ||= ''
      variables['defaults']['log'] << new_resource.log
      variables['defaults']['mode'] ||= ''
      variables['defaults']['mode'] << new_resource.mode
      variables['defaults']['balance'] ||= '' unless new_resource.balance.nil?
      variables['defaults']['balance'] << new_resource.balance unless new_resource.balance.nil?
      variables['defaults']['option'] ||= []
      (variables['defaults']['option'] << new_resource.option).flatten!
      variables['defaults']['stats'] ||= {}
      variables['defaults']['stats'].merge!(new_resource.stats)
      variables['defaults']['maxconn'] ||= '' unless new_resource.maxconn.nil?
      variables['defaults']['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
      variables['defaults']['retries'] ||= '' unless new_resource.haproxy_retries.nil?
      variables['defaults']['retries'] << new_resource.haproxy_retries.to_s unless new_resource.haproxy_retries.nil?
      variables['defaults']['hash_type'] = new_resource.hash_type unless new_resource.hash_type.nil?
      variables['defaults']['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['defaults']['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
