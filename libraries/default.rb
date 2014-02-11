# No namespace!?
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

module ChefHaproxy
  class << self
    def config_generator(thing, prefix)
      result = []
      case thing
      when Hash
        thing.each do |key, value|
          case value
          when Hash, Array
            result.push config_generator(
              value, [prefix, key.to_s].compact.join(' ')
            )
          when TrueClass, FalseClass
            if(value)
              result << [prefix, key.to_s].compact.join(' ')
            end
          else
            result << [prefix, key.to_s, value.to_s].compact.join(' ')
          end
        end
      when Array
        thing.each do |v|
          result << [prefix, v.to_s].compact.join(' ')
        end
      else
        raise TypeError.new("Expecting Hash or Array type. Received: #{thing.class}")
      end
      result.join("\n")
    end
  end
end
