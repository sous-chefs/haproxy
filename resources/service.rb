include Haproxy::Cookbook::Helpers

use 'partial/_config_file'

property :bin_prefix, String,
          default: '/usr',
          description: 'Bin location of the haproxy binary, defaults to /usr'

property :service_name, String,
          default: 'haproxy'

property :systemd_unit_content, [String, Hash],
          default: lazy { default_systemd_unit_content },
          description: 'HAProxy systemd unit contents'

property :config_test, [true, false],
          default: true,
          description: 'Perform configuration file test before performing service action'

property :config_test_fail_action, Symbol,
          equal_to: %i(raise log),
          default: :raise,
          description: 'Action to perform upon configuration test failure.'

unified_mode true

action_class do
  include Haproxy::Cookbook::Helpers

  def do_service_action(resource_action)
    with_run_context(:root) do
      if %i(start restart reload).include?(resource_action)
        begin
          if new_resource.config_test && ::File.exist?(new_resource.config_file)
            log 'Running configuration test'
            cmd = Mixlib::ShellOut.new("#{systemd_command(new_resource.bin_prefix)} -c -V -f #{new_resource.config_file}")
            cmd.run_command.error!
            Chef::Log.info("Configuration test passed, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
          elsif new_resource.config_test && !::File.exist?(new_resource.config_file)
            log 'Configuration test is enabled but configuration file does not exist, skipping test' do
              level :warn
            end
          else
            Chef::Log.info("Configuration test disabled, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
          end

          declare_resource(:service, new_resource.service_name).delayed_action(resource_action)
        rescue Mixlib::ShellOut::ShellCommandFailed
          if new_resource.config_test_fail_action.eql?(:log)
            Chef::Log.error("Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\n"\
                            "Error\n-----\n#{cmd.stderr}")
          else
            raise "Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\n"\
                  "Error\n-----\nAction: #{resource_action}\n#{cmd.stderr}"
          end
        end
      else
        declare_resource(:service, new_resource.service_name).delayed_action(resource_action)
      end
    end
  end
end

action :create do
  with_run_context :root do
    declare_resource(:cookbook_file, '/etc/default/haproxy') do
      cookbook 'haproxy'
      source 'haproxy-default'
      owner 'root'
      group 'root'
      mode '0644'
    end

    declare_resource(:systemd_unit, "#{new_resource.service_name}.service") do
      content new_resource.systemd_unit_content
      triggers_reload true
      action :create
    end
  end
end

action :delete do
  with_run_context :root do
    declare_resource(:cookbook_file, '/etc/default/haproxy').action(:delete)
    declare_resource(:systemd_unit, "#{new_resource.service_name}.service").action(:delete)
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
