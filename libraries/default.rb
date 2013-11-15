def haproxy_defaults_options
  options = node['haproxy']['defaults_options']
  if node['haproxy']['x_forwarded_for']
    options.push("forwardfor")
  end
  return options.uniq
end

def haproxy_defaults_timeouts
  node['haproxy']['defaults_timeouts']
end

def haproxy_global_log1
  log1 = "log #{node['haproxy']['global_log1']['address']} #{node['haproxy']['global_log1']['facility']}"
  log1 << node['haproxy']['global_log1']['max_level'] unless node['haproxy']['global_log1']['max_level'].nil?
  log1 << node['haproxy']['global_log1']['min_level'] unless node['haproxy']['global_log1']['min_level'].nil?
  return log1
end

def haproxy_global_log2
  if node['haproxy']['global_log2'].nil?
    return nil
  else
    log2 = "log #{node['haproxy']['global_log2']['address']} #{node['haproxy']['global_log2']['facility']}"
    log2 << node['haproxy']['global_log2']['max_level'] unless node['haproxy']['global_log2']['max_level'].nil?
    log2 << node['haproxy']['global_log2']['min_level'] unless node['haproxy']['global_log2']['min_level'].nil?
    return log2
  end
end