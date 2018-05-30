property :use_backend, [String, Array], name_property: true
property :section, String, required: true, equal_to: %w(frontend listen backend)
property :section_name, String, required: true
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

description <<-EOL
Switch to a specific backend if/unless an ACL-based condition is matched.
EOL

examples <<-EOL
```
haproxy_use_backend 'gina if gina_host' do
  section 'frontend'
  section_name 'http'
end
```
```
haproxy_use_backend 'use_backends for frontend:http' do
  section 'frontend'
  section_name 'http'
  use_backend [
    'rrhost if rrhost_host',
    'tiles_public if tile_host',
  ]
end
```
EOL

introduced 'v4.2.0'

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables[new_resource.section] ||= {}
      variables[new_resource.section][new_resource.section_name]['use_backend'] ||= []
      variables[new_resource.section][new_resource.section_name]['use_backend'] += Array(new_resource.use_backend)

      action :nothing
      delayed_action :create
    end
  end
end
