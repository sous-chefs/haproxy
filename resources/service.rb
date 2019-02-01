property :bin_prefix, String, default: '/usr'
property :config_dir,  String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :service_name, String, default: 'haproxy'
property :use_systemd, [true, false], default: lazy { node['init_package'] == 'systemd' }
property :systemd_unit, Hash, default: {}

action :create do
  Chef::Log.info 'Running haproxy_service Create'

  with_run_context :root do
    find_resource(:user, new_resource.haproxy_user) do
      home "/home/#{new_resource.haproxy_user}"
      action :create
    end

    find_resource(:group, new_resource.haproxy_group) do
      members new_resource.haproxy_user
      action :create
    end

    cookbook_file '/etc/default/haproxy' do
      cookbook 'haproxy'
      source 'haproxy-default'
      owner 'root'
      group 'root'
      mode '0644'
    end

    case node['init_package']
    when 'systemd'
      haproxy_systemd_command = if haproxy_version < 1.8
                                  ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy-systemd-wrapper')
                                else
                                  ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy') + ' -Ws'
                                end
      if new_resource.systemd_unit.empty?
        new_resource.systemd_unit = {
          'Unit' => {
            'Description' => new_resource.service_name,
            'After' => 'syslog.target network.target'
          },
          'Service' => {
            'Environment' => "CONFIG=#{new_resource.config_file} PIDFILE='/run/haproxy.pid'",
            'ExecStartPre' => "#{new_resource.bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
            'ExecStart' => "#{haproxy_systemd_command} -f #{new_resource.config_file} -p /run/haproxy.pid $OPTIONS",
            'ExecReload' => "#{new_resource.bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
            'ExecReload' => '/bin/kill -USR2 $MAINPID',
            'KillSignal' => 'SIGTERM',
            'User' => new_resource.haproxy_user,
            'WorkingDirectory' => "/home/#{new_resource.haproxy_user}",
            'KillMode' => 'mixed',
            'Restart' => 'always',
          },
        }
      end
      systemd_unit "#{new_resource.service_name}.service" do
        content new_resource.systemd_unit
        triggers_reload true
        action [:create, :enable]
        notifies :restart, "service[#{new_resource.service_name}]", :delayed
      end

      service new_resource.service_name do
        supports status: true, restart: true
        delayed_action [:enable, :start]
      end
    end
  else
    poise_service new_resource.service_name do
      provider :sysvinit
      command ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy')
      options template: 'haproxy:haproxy-init.erb',
              hostname: node['hostname'],
              conf_dir: new_resource.config_dir,
              pid_file: '/var/run/haproxy.pid',
              run_dir: '/run/haproxy',
              haproxy_user: new_resource.haproxy_user,
              haproxy_group: new_resource.haproxy_group
      action :nothing
      delayed_action :enable
    end
  end

  # with_run_context :root do
  #   find_resource(:poise_service_user, new_resource.haproxy_user) do
  #     home "/home/#{new_resource.haproxy_user}"
  #     group new_resource.haproxy_group
  #     action :create
  #   end

  #   cookbook_file '/etc/default/haproxy' do
  #     cookbook 'haproxy'
  #     source 'haproxy-default'
  #     owner 'root'
  #     group 'root'
  #     mode '0644'
  #   end

  #   case node['init_package']
  #   when 'systemd'
  #     haproxy_systemd_command = if haproxy_version < 1.8
  #                                 ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy-systemd-wrapper')
  #                               else
  #                                 ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy') + ' -Ws'
  #                               end
  #     poise_service 'haproxy' do
  #       provider :systemd
  #       command "#{haproxy_systemd_command} -f #{new_resource.config_file} -p /run/haproxy.pid $OPTIONS"
  #       options reload_signal: 'USR2',
  #               restart_mode: 'always',
  #               after_target: 'network',
  #               auto_reload: true,
  #               conf_file: new_resource.config_file,
  #               pid_file: '/run/haproxy.pid',
  #               bin_prefix: new_resource.bin_prefix,
  #               template: 'haproxy:haproxy.service.erb'
  #       action :nothing
  #       delayed_action :enable
  #     end
  #   else

  #   end
  # end
end

action :start do
  with_run_context :root do
    find_resource(:service, new_resource.service_name) do
    end.run_action(:start)
  end
end

action :stop do
  with_run_context :root do
    find_resource(:service, new_resource.service_name) do
    end.run_action(:stop)
  end
end

action :restart do
  with_run_context :root do
    find_resource(:service, new_resource.service_name) do
    end.run_action(:restart)
  end
end

action :reload do
  with_run_context :root do
    find_resource(:service, new_resource.service_name) do
    end.run_action(:reload)
  end
end

action :enable do
  with_run_context :root do
    find_resource(:service, new_resource.service_name) do
    end.run_action(:enable)
  end
end

action_class do
  include Chef::Haproxy::Helpers
end
