include Chef::Haproxy::Helpers

property :bin_prefix, String, default: '/usr'
property :config_dir,  String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :service_name, String, default: 'haproxy'
property :use_systemd, [true, false], default: lazy { node['init_package'] == 'systemd' }
property :systemd_unit, Hash,
         description: 'Set to change the SystemD Unit parameters',
         default: lazy {
           {
           Unit: {
             Description: service_name,
             After: 'syslog.target network.target',
           },
           Service: {
             Environment: "CONFIG=#{config_file} PIDFILE='/run/haproxy.pid'",
             EnvironmentFile: "-/etc/default/haproxy",
             ExecStartPre: "#{bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
             ExecStart: "#{systemd_command(bin_prefix)} -f #{config_file} -p /run/haproxy.pid $OPTIONS",
             ExecReload: "#{bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
             ExecReload: '/bin/kill -USR2 $MAINPID',
             KillMode: 'mixed',
             Restart: 'always',
             Type: 'notify'
           },
           Install: {
             WantedBy: 'multi-user.target'
           }
          }
         }

action :create do
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
