actions :create, :delete
default_action :create

attribute :config_directory, :kind_of => String

def config(value=:none, &block)
  if(value != :none)
    unless(value.is_a?(Hash))
      raise Exception::ValidationFailed, "Option config must be of kind Hash! You passed #{value.inspect}"
    end
    @config = value
  elsif(block)
    @config = block
  else
    @config
  end
end
