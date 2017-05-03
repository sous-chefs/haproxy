property :install_type, String, name_property: true, equal_to: %w(package source)
property :config_template_source, String, default: 'haproxy.cfg.erb'
property :bin_prefix, String, default: '/usr'
property :config_dir,  String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'

# Package
property :package_name, String, default: 'haproxy'
property :package_version, [String, nil], default: nil

# Source
property :source_version, String, default: '1.7.5'
property :source_url, String, default: 'http://www.haproxy.org/download/1.7/src/haproxy-1.7.5.tar.gz'
property :source_checksum, String, default: 'b04d7db6383c662eb0a421a95af7becac6d9744a1abf0df6b0280c1e61416121'
property :source_target_cpu, [String, nil], default: lazy { node['kernel']['machine'] }
property :source_target_arch, [String, nil], deafult: nil
property :source_target_os, String, default: lazy {
  if node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6
    @target_os = 'linux2628'
  elsif (node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6) && (node['kernel']['release'].split('.')[2].split('-').first.to_i > 28)
    @target_os = 'linux2628'
  elsif (node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6) && (node['kernel']['release'].split('.')[2].split('-').first.to_i < 28)
    @target_os = 'linux26'
  else
    'generic'
  end
}
property :use_pcre,         String, equal_to: %w(0 1), default: '1'
property :use_openssl,      String, equal_to: %w(0 1), default: '1'
property :use_zlib,         String, equal_to: %w(0 1), default: '1'
property :use_linux_tproxy, String, equal_to: %w(0 1), default: '1'
property :use_linux_splice, String, equal_to: %w(0 1), default: '1'

action :create do
  poise_service_user new_resource.haproxy_user do
    home '/home/haproxy'
    group new_resource.haproxy_group
    action :create
  end

  case install_type
  when 'package'
    package package_name do
      version package_version if package_version
      action :install
    end

  when 'source'
    include_recipe 'build-essential'

    pkg_list = value_for_platform_family(
      'debian' => %w(libpcre3-dev libssl-dev zlib1g-dev),
      'rhel' => %w(pcre-devel openssl-devel zlib-devel),
      'amazon' => %w(pcre-devel openssl-devel zlib-devel)
    )

    package pkg_list

    remote_file 'haproxy source file' do
      path ::File.join(Chef::Config[:file_cache_path], "haproxy-#{source_version}.tar.gz")
      source source_url
      checksum source_checksum
      action :create
    end

    make_cmd = "make TARGET=#{source_target_os}"
    make_cmd << " CPU=#{source_target_cpu}" unless source_target_cpu.nil?
    make_cmd << " ARCH=#{source_target_arch}" unless source_target_arch.nil?
    make_cmd << " USE_PCRE=#{use_pcre}"
    make_cmd << " USE_OPENSSL=#{use_openssl}"
    make_cmd << " USE_ZLIB=#{use_zlib}"
    make_cmd << " USE_LINUX_TPROXY=#{use_linux_tproxy}"
    make_cmd << " USE_LINUX_SPLICE=#{use_linux_splice}"

    extra_cmd = ' EXTRA=haproxy-systemd-wrapper' if node['init_package'] == 'systemd'

    bash 'compile_haproxy' do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        tar xzf haproxy-#{source_version}.tar.gz
        cd haproxy-#{source_version}
        #{make_cmd} && make install PREFIX=#{bin_prefix} #{extra_cmd}
      EOH
      not_if "#{::File.join(bin_prefix, 'sbin', 'haproxy')} -v | grep #{source_version}"
    end

    poise_service_user new_resource.haproxy_user do
      home '/home/haproxy'
      group new_resource.haproxy_group
      action :create
    end
  end

  with_run_context :root do
    directory new_resource.config_dir do
      owner new_resource.haproxy_user
      group new_resource.haproxy_group
      mode '0755'
      recursive true
      action :create
    end

    template config_file do
      source 'haproxy.cfg.erb'
      owner new_resource.haproxy_user
      group new_resource.haproxy_group
      mode '0644'
      cookbook 'haproxy'
      notifies :enable, 'poise_service[haproxy]', :immediately
      notifies :restart, 'poise_service[haproxy]', :delayed
      variables()
      action :nothing
      delayed_action :nothing
    end

    if node['init_package'] == 'systemd'
      haproxy_systemd_wrapper = ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy-systemd-wrapper')

      poise_service 'haproxy' do
        provider :systemd
        command "#{haproxy_systemd_wrapper} -f #{new_resource.config_file} -p /run/haproxy.pid $OPTIONS"
        options reload_signal: 'USR2',
                restart_mode: 'always',
                after_target: 'network',
                auto_reload: true
        action :nothing
      end
    else
      poise_service 'haproxy' do
        provider :sysvinit
        command ::File.join(new_resource.bin_prefix, 'sbin', 'haproxy')
        options template: 'haproxy:haproxy-init.erb',
                hostname: node['hostname'],
                conf_dir: new_resource.config_dir,
                pid_file: '/var/run/haproxy.pid'
        action :nothing
      end

      cookbook_file '/etc/default/haproxy' do
        cookbook 'haproxy'
        source 'haproxy-default'
        owner 'root'
        group 'root'
        mode '0644'
      end
    end
  end
end

action :start do
  with_run_context :root do
    poise_service 'haproxy' do
      action :start
    end
  end
end

action :stop do
  with_run_context :root do
    poise_service 'haproxy' do
      action :stop
    end
  end
end

action :restart do
  with_run_context :root do
    poise_service 'haproxy' do
      action :restart
    end
  end
end

action :reload do
  with_run_context :root do
    poise_service 'haproxy' do
      action :reload
    end
  end
end
