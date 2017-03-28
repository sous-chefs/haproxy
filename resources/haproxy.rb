property :install_type, String, default: 'package', name_property: true, equal_to: %w(package source)

property :client_timeout, String, default: '10s'
property :server_timeout, String, default: '10s'
property :connect_timeout, String, default: '10s'
property :config_cookbook, String, default: 'haproxy'
property :config_template_source, String, default: 'haproxy.cfg.erb'
property :config_dir, String, default: '/etc/haproxy'
property :bin_prefix, String, default: '/usr/sbin'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'

property :enable_default_http, [TrueClass, FalseClass], default: true
property :mode, String, default: 'http', equal_to: %w(http)
property :ssl_mode, String, default: 'http'
property :bind_address, String, default: '0.0.0.0'
property :bind_port, Integer, default: 80

# Package
property :package_name, String, default: 'haproxy'
property :package_version, [String, nil], default: nil

# Source
property :source_prefix, String, deafult: '/usr/local'
property :source_version, String, default: '1.7.4'
property :source_url, String, default: 'http://www.haproxy.org/download/1.7/src/haproxy-1.7.4.tar.gz'
property :source_checksum, String, default: 'dc1e7621fd41a1c3ca5621975ca5ed4191469a144108f6c47d630ca8da835dbe'
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

resource_name :haproxy

action :create do
  case install_type
  when 'package'
    package package_name do
      version package_version if package_version
      action :install
    end

  when 'source'
    # node.override['haproxy']['poise_service']['options']['sysvinit']['conf_dir'] = config_dir

    pkg_list = value_for_platform_family(
      'debian' => %w(libpcre3-dev libssl-dev zlib1g-dev),
      'rhel' => %w(pcre-devel openssl-devel zlib-devel)
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
    make_cmd << " use_pcre #{use_pcre}"
    make_cmd << " use_openssl #{use_openssl}"
    make_cmd << " use_zlib #{use_zlib}"
    make_cmd << " use_linux_tproxy #{use_linux_tproxy}"
    make_cmd << " use_linux_splice #{use_linux_splice}"

    extra_cmd = ' EXTRA=haproxy-systemd-wrapper' if node['init_package'] == 'systemd'

    bash 'compile_haproxy' do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        tar xzf haproxy-#{source_version}.tar.gz
        cd haproxy-#{source_version}
        #{make_cmd} && make install PREFIX=#{bin_prefix} #{extra_cmd}
      EOH
      not_if "#{::File.join(bin_prefix, 'haproxy')} -v | grep #{source_version}"
    end

    directory config_dir do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end

    haproxy_command = if node['init_package'] == 'systemd'
                        "#{::File.join(bin_prefix, 'haproxy-systemd-wrapper')} -f #{config_file} -p /run/haproxy.pid $OPTIONS"
                      else
                        ::File.join(bin_prefix, 'haproxy')
                      end

    poise_service 'haproxy' do
      provider node['init_package']
      command haproxy_command
      options node['haproxy']['poise_service']['options'][node['init_package']]
      action :enable
    end
  end
end

action :start do
  poise_service 'haproxy' do
    action :start
  end
end

action :stop do
  poise_service 'haproxy' do
    action :stop
  end
end

action :restart do
  poise_service 'haproxy' do
    action :restart
  end
end

action :reload do
  poise_service 'haproxy' do
    action :reload
  end
end
