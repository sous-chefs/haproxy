use_inline_resources if defined?(use_inline_resources)

action :create do
  group = "group #{new_resource.name}"
  group << " users #{new_resource.users.join(',')}" if new_resource.users
  node.default['haproxy']['userlists'][new_resource.userlist]['groups'][new_resource.name] = group
end

