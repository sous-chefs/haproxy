property :mailer, [String, Array],
         description: 'Defines a mailer inside a mailers section'
property :timeout, String,
         description: 'Defines the time available for a mail/connection to be made and send to the mail-server'
property :config_dir, String,
         default: '/etc/haproxy',
         description: 'The directory where the HAProxy configuration resides'
property :config_file, String,
         default: lazy { ::File.join(config_dir, 'haproxy.cfg') },
         description: 'The HAProxy configuration file'
property :config_cookbook, String,
         default: 'haproxy',
         description: 'Used to configure loading config from another cookbook'

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_cookbook] ||= 'haproxy' }
      variables['mailer'] ||= {}
      variables['mailer'][new_resource.name] ||= {}
      variables['mailer'][new_resource.name]['mailer'] ||= [new_resource.mailer].flatten unless new_resource.mailer.nil?
      variables['mailer'][new_resource.name]['timeout'] ||= new_resource.timeout unless new_resource.timeout.nil?

      action :nothing
      delayed_action :create
    end
  end
end
