property :fastcgi, String, name_property: true
property :docroot, String
property :index, String
property :log_stderr, String
property :option, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

unified_mode true

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['fastcgi'] ||= {}
      variables['fastcgi'][new_resource.fastcgi] ||= {}
      variables['fastcgi'][new_resource.fastcgi]['docroot'] ||= new_resource.docroot unless new_resource.docroot.nil?
      variables['fastcgi'][new_resource.fastcgi]['index'] ||= new_resource.index unless new_resource.index.nil?
      variables['fastcgi'][new_resource.fastcgi]['log_stderr'] ||= new_resource.log_stderr unless new_resource.log_stderr.nil?
      variables['fastcgi'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
      variables['fastcgi'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
      variables['fastcgi'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['fastcgi'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
