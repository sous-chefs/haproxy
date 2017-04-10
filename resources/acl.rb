# frozen_string_literal: true
property :name, String
property :section, String, equal_to: %w(frontend listen backend), name_attribute: true
property :criterion, [String, nil]
property :flags, [String, nil]
property :operator, [String, nil]
property :value, [String, nil]

action :create do
  with_run_context :root do
    template config_file do
      source 'haproxy.cfg.erb'
      cookbook 'haproxy'
      variables[new_resource.section]['acl'] ||= {}
      variables[new_resource.section]['acl'][new_resource.name] = "#{new_resource.criterion} #{new_resource.flags} #{new_resource.operator} #{new_resource.value}"
      action :nothing
      delayed_action :create
    end
  end
end

# acl destination_jasper path_beg /jasperserver/
# acl tile_host	hdr(host)	-i -f /etc/haproxy/tile_domains.lst
