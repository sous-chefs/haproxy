if defined?(ChefSpec)

  # ChefSpec.define_matcher :haproxy
  # ChefSpec.define_matcher :haproxy_lb
  # ChefSpec.define_matcher :haproxy_config

  def create_haproxy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:haproxy, :create, resource_name)
  end

  # def delete_haproxy(name)
  #   ChefSpec::Matchers::ResourceMatcher.new(:haproxy, :delete, name)
  # end
  #
  # def create_service_haproxy(name)
  #   ChefSpec::Matchers::ResourceMatcher.new(:haproxy, :create_service, name)
  # end
  #
  # def create_haproxy_lb(name)
  #   ChefSpec::Matchers::ResourceMatcher.new(:haproxy_lb, :create, name)
  # end
  #
  # def create_haproxy_config(name)
  #   ChefSpec::Matchers::ResourceMatcher.new(:haproxy_config, :create, name)
  # end
end
