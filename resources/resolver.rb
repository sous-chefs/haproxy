property :name, String, name_property: true
property :nameserver, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    default_conf
    edit_resource(:template, config_file) do |new_resource|
      source node['haproxy']['conf_template_source']
      cookbook node['haproxy']['conf_cookbook']
      variables['resolvers'] ||= {}
      variables['resolvers'][new_resource.name] ||= {}
      variables['resolvers'][new_resource.name]['nameserver'] ||= [] unless new_resource.nameserver.nil?
      variables['resolvers'][new_resource.name]['nameserver'] << new_resource.nameserver unless new_resource.nameserver.nil?
      variables['resolvers'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['resolvers'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
