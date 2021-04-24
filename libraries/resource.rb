module Haproxy
  module Cookbook
    module ResourceHelpers
      def haproxy_config_resource_init
        haproxy_config_resource_create unless haproxy_config_resource_exist?
      end

      def haproxy_config_resource
        return unless haproxy_config_resource_exist?

        find_resource!(:template, new_resource.config_file)
      end

      private

      def haproxy_config_resource_exist?
        !find_resource!(:template, new_resource.config_file).nil?
      rescue Chef::Exceptions::ResourceNotFound
        false
      end

      def haproxy_config_resource_create
        with_run_context(:root) do
          declare_resource(:directory, ::File.dirname(new_resource.config_file)) do
            owner new_resource.haproxy_user
            group new_resource.haproxy_group
            mode '0755'

            recursive true

            action :create
          end

          declare_resource(:template, new_resource.config_file) do
            cookbook new_resource.conf_cookbook
            source new_resource.conf_template_source

            owner new_resource.haproxy_user
            group new_resource.haproxy_group
            mode new_resource.conf_file_mode
            sensitive new_resource.sensitive

            action :nothing
            delayed_action :create
          end
        end
      end
    end
  end
end
