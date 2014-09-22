if defined?(ChefSpec)
  def create_haproxy
    ChefSpec::Matchers::ResourceMatcher.new(:haproxy, :create)
  end

  def delete_haproxy
    ChefSpec::Matchers::ResourceMatcher.new(:haproxy, :delete)
  end

  def create_haproxy_lb(name)
    ChefSpec::Matchers::ResourceMatcher.new(:haproxy_lb, :create, name)
  end

  def create_haproxy_config(name)
    ChefSpec::Matchers::ResourceMatcher.new(:haproxy_config, :create, name)
  end
end
