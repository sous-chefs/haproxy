if defined?(ChefSpec)
  custom_resources = {
    haproxy_acl: [:create],
    haproxy_backend: [:create],
    haproxy_config_defaults: [:create],
    haproxy_config_global: [:create],
    haproxy_frontend: [:create],
    haproxy_install: [:create, :start, :stop, :restart, :reload],
    haproxy_listen: [:create],
    haproxy_use_backend: [:create],
    haproxy_userlist: [:create],
  }

  custom_resources.each do |resource, actions|
    actions.each do |action|
      define_method("#{action}_#{resource}") do |message|
        ChefSpec::Matchers::ResourceMatcher
          .new(resource.to_sym, action, message)
      end
    end
  end
end
