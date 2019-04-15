include Chef::Haproxy::Helpers

property :bin_prefix, String, default: '/usr'
property :config_dir,  String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :service_name, String, default: 'haproxy'
property :systemd_unit_content, [String, Hash], default: ''

action :create do
  with_run_context :root do
    cookbook_file '/etc/default/haproxy' do
      cookbook 'haproxy'
      source 'haproxy-default'
      owner 'root'
      group 'root'
      mode '0644'
    end

    if new_resource.systemd_unit_content == ''
      new_resource.systemd_unit_content <<-EOU.gsub(/^\s+/, '')
[Unit]
Description=HAProxy Load Balancer
Documentation=file:/usr/share/doc/haproxy/configuration.txt.gz
After=network.target syslog.service

[Service]
EnvironmentFile=-/etc/default/haproxy
Environment="CONFIG=#{new_resource.config_file}" "PIDFILE=/run/haproxy.pid"
ExecStartPre=#{new_resource.bin_prefix}/sbin/haproxy -f $CONFIG -c -q
ExecStart=#{systemd_command(new_resource.bin_prefix)} -f $CONFIG -p $PIDFILE $OPTIONS
ExecReload=#{new_resource.bin_prefix}/sbin/haproxy -f $CONFIG -c -q
ExecReload=/bin/kill -USR2 $MAINPID
KillSignal=TERM
User=root
WorkingDirectory=/
KillMode=mixed
Restart=always

[Install]
WantedBy=multi-user.target
      EOU
    end

    systemd_unit "#{new_resource.service_name}.service" do
      content new_resource.systemd_unit_content
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
