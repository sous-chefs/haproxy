use_inline_resources if defined?(use_inline_resources)

action :create do
  node.default['haproxy']['userlists'][new_resource.name] = {
    'groups' => {},
    'stored_salts' => {},
    'users' => {}
  }
end

