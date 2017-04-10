# property :name, String
# property :section, String, equal_to: %w(frontend listen backend), name_attribute: true
# property :section_name, String, default: 'default'
# property :criterion, String
# property :flags, String
# property :operator, String
# property :value, String
#
# action :create do
# end

# acl destination_jasper path_beg /jasperserver/
# acl tile_host	hdr(host)	-i -f /etc/haproxy/tile_domains.lst
