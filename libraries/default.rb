def haproxy_defaults_options
  options = node['haproxy']['defaults_options'].dup
  if node['haproxy']['x_forwarded_for']
    options.push("forwardfor")
  end
  return options.uniq
end

def haproxy_defaults_timeouts
  node['haproxy']['defaults_timeouts']
end
