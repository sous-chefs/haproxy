property :name, String, name_property: true
property :type, String, equal_to: ['user', 'group']
property :list_name, String, required: true
property :list_item, String, required: true

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, config_file) do |new_resource|
      cookbook 'haproxy'
      variables['userlist'] ||= {}
      variables['userlist'][new_resource.name] ||= {}
      variables['userlist'][new_resource.name][new_resource.type] ||= []
      variables['userlist'][new_resource.name][new_resource.type] << new_resource.list_item
    end
  end
end
