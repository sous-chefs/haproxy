property :name, String, name_property: true
property :group, Hash
property :user, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, config_file) do |new_resource|
      cookbook 'haproxy'
      variables['userlist'] ||= {}
      variables['userlist'][new_resource.name] ||= {}
      variables['userlist'][new_resource.name]['group'] ||= []
      variables['userlist'][new_resource.name]['group'] << new_resource.group unless new_resource.group.nil?
      variables['userlist'][new_resource.name]['user'] ||= []
      variables['userlist'][new_resource.name]['user'] << new_resource.user unless new_resource.user.nil?

      action :nothing
      delayed_action :create
    end
  end
end
