def defaults_options
  options = node['haproxy']['defaults_options']
  if node['haproxy']['x_forwarded_for']
    options.push("forwardfor")
  end
  return options.uniq
end

def defaults_timeouts
  node['haproxy']['defaults_timeouts']
end
