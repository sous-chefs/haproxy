property :acl, [String,Array], name_property: true
property :section, String, required: true, equal_to: ['frontend','listen','backend']
property :section_name, String, required: true

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, config_file) do |new_resource|
      cookbook 'haproxy'
      variables[new_resource.section] ||= {}
      variables[new_resource.section][new_resource.section_name]['acl'] ||= []
      variables[new_resource.section][new_resource.section_name]['acl'] << new_resource.acl if new_resource.is_a? String
      variables[new_resource.section][new_resource.section_name]['acl'] += new_resource.acl if new_resource.is_a? Array

      action :nothing
      delayed_action :create
    end
  end
end
