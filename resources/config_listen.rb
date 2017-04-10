# a "listen" section defines a complete proxy with its frontend and backend
# parts combined in one section. It is generally useful for TCP-only traffic.

# property :http_check_disable_on_404, [TrueClass, FalseClass, nil], default: true
# property :http_check_expect, [String, nil]
# property :http_check_send_state, [TrueClass, FalseClass, nil]
# property :http_request, [String, nil]
# property :http_response, [String, nil]
# property :http_reuse, [String, nil], equal_to: %w(never safe aggressive always)
# property :http_send_name_header, [String, nil]
#
# action :create do
#
# end
# owner node['haproxy']['user']
# group node['haproxy']['group']
