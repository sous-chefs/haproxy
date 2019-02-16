property :name, String, name_property: true
property :total_max_size, Integer
property :max_object_size, Integer
property :max_age, Integer
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
      variables['cache'] ||= {}
      variables['cache'][new_resource.name] ||= {}
      variables['cache'][new_resource.name]['total_max_size'] ||= new_resource.total_max_size
      variables['cache'][new_resource.name]['max_object_size'] ||= new_resource.max_object_size unless new_resource.max_object_size.nil?
      variables['cache'][new_resource.name]['max_age'] ||= new_resource.max_age unless new_resource.max_age.nil?

      action :nothing
      delayed_action :create
    end
  end
end
