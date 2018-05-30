property :acl, [String, Array], name_property: true
property :section, String, required: true, equal_to: %w(frontend listen backend)
property :section_name, String, required: true
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

description <<-EOL
Access Control Lists creates a new ACL <aclname> or completes an existing one with new tests.

The actions generally consist in blocking a request, selecting a backend, or adding a header.
EOL

examples <<-EOL
```
haproxy_acl 'gina_host hdr(host) -i foo.bar.com' do
  section 'frontend'
  section_name 'http'
end
```
```
haproxy_acl 'acls for frontend:http' do
  section 'frontend'
  section_name 'http'
  acl [
    'rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com',
    'tile_host hdr(host) -i dough.foo.bar.com',
  ]
end
```
```
haproxy_acl 'acls for listen' do
  section 'listen'
  section_name 'admin'
  acl ['network_allowed src 127.0.0.1']
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
      variables[new_resource.section][new_resource.section_name]['acl'] ||= []
      variables[new_resource.section][new_resource.section_name]['acl'] += Array(new_resource.acl)

      action :nothing
      delayed_action :create
    end
  end
end
