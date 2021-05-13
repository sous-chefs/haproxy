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
            owner new_resource.user
            group new_resource.group
            mode new_resource.config_dir_mode

            recursive true

            action :create
          end

          declare_resource(:template, new_resource.config_file) do
            cookbook new_resource.cookbook
            source new_resource.template

            owner new_resource.user
            group new_resource.group
            mode new_resource.config_file_mode
            sensitive new_resource.sensitive

            helpers(Haproxy::Cookbook::TemplateHelpers)

            action :nothing
            delayed_action :create
          end
        end
      end
    end
  end
end
