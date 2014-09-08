# No namespace!?
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
