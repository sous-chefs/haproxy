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

def walk(data)
  a = []
  data.each do |key,value|
    case value
    when TrueClass
      a << key
    when FalseClass
      nil
    when Array
      a << value.map { |v| "  #{key} #{v}" }.join("\n")
    when Hash
      a << walk(value)
    else
      a << "  #{key} #{value}"
    end
  end
  return a
end

def haproxy_configuration
  a = []
  ['global', 'defaults', 'listen', 'frontend', 'backend' ].each do |section|
    a << section
    a << walk(node['haproxy']['config'][section])
  end
  return a.join("\n")
end
