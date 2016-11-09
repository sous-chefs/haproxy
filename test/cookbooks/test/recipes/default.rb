apt_update 'update'

if platform_family?('rhel', 'fedora')
  package 'nc'
else
  package 'netcat'
end

include_recipe 'haproxy::manual'
