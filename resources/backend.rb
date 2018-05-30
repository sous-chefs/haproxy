property :mode, String, equal_to: %w(http tcp)
property :server, Array
property :tcp_request, Array
property :acl, Array
property :option, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

description <<-EOL
Backend describes a set of servers to which the proxy will connect to forward incoming connections.
EOL

examples <<-EOL
```
haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end
```
```
haproxy_backend 'tiles_public' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
  tcp_request ['content track-sc2 src',
               'content reject if conn_rate_abuse mark_as_abuser']
  option %w(httplog dontlognull forwardfor)
  acl ['conn_rate_abuse sc2_conn_rate gt 3000',
       'data_rate_abuse sc2_bytes_out_rate gt 20000000',
       'mark_as_abuser sc1_inc_gpc0 gt 0',
     ]
  extra_options(
    'stick-table' => 'type ip size 200k expire 2m store conn_rate(60s),bytes_out_rate(60s)',
    'http-request' => 'set-header X-Public-User yes'
  )
end
```
EOL

introduced 'v4.0.0'

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['backend'] ||= {}
      variables['backend'][new_resource.name] ||= {}
      variables['backend'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
      variables['backend'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
      variables['backend'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
      variables['backend'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
      variables['backend'][new_resource.name]['tcp_request'] ||= [] unless new_resource.tcp_request.nil?
      variables['backend'][new_resource.name]['tcp_request'] << new_resource.tcp_request unless new_resource.tcp_request.nil?
      variables['backend'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
      variables['backend'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
      variables['backend'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
      variables['backend'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
      variables['backend'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['backend'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
