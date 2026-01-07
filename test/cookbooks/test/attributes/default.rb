# Disable epel-next for CentOS Stream 10 as it doesn't exist
if platform_family?('rhel') && node['platform_version'].to_i >= 10
  default['yum']['epel-next']['managed'] = false
end
