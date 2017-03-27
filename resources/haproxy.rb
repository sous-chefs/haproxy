property :name, String, default: 'default', name_property: true
property :install_type, String, default: 'package', equal_to: %w(package source)

property :client_timeout, String, default: '10s'
property :server_timeout, String, default: '10s'
property :connect_timeout, String, default: '10s'
property :config_cookbook, String, default: 'haproxy'
property :config_template_source, String, default: 'haproxy.cfg.erb'
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'

property :enable_default_http, [TrueClass, FalseClass], default: true
property :haproxy_mode, String, default: 'http', equal_to: %w(http)
property :ssl_mode, String, default: 'http'
property :bind_address, String, default: '0.0.0.0'
property :bind_port, Integer, default: 80

# Package
property :package_name, String, default: 'haproxy'
property :package_version, String, default: nil

# Source
property :source_prefix, String, deafult: node['haproxy']['source']['prefix']
property :source_version, String, default: node['haproxy']['source']['version']
property :source_url, String, default: node['haproxy']['source']['url']
property :source_checksum, String, default: node['haproxy']['source']['checksum']
property :source_target_os, String, default: node['haproxy']['source']['target_os']
property :source_target_cpu, [String, Nil], default: lazy { node['haproxy']['source']['target_cpu'] }
property :source_target_arch, [String, Nil], deafult: lazy { node['haproxy']['source']['target_arch'] }

property :use_pcre, Integer, equal_to: %w{0 1}, default: '1'
property :use_openssl, Integer, equal_to: %w{0 1}, default: '1'
property :use_zlib, String, equal_to: %{0 1}, default: '1'
property :use_linux_tproxy, Integer, equal_to: %w{0 1}, default: '1'
property :use_linux_splice, Integer, equal_to: %w{0 1}, default: '1'


action :create do
  case install_type
  when 'package'
    config_dir = '/etc/haproxy'
    config_file = ::File.join(config_dir, 'haproxy.cfg')
    bin_prefix = '/usr/sbin'

    package package_name do
      version package_version if package_version
      action :install
    end

  when 'source'
    prefix = source_prefix
    config_dir = ::File.join(prefix, '/etc/haproxy')
    config_file = ::File.join(config_dir, 'haproxy.cfg')
    bin_prefix = ::File.join(prefix, 'sbin')
    node.override['haproxy']['poise_service']['options']['sysvinit']['conf_dir'] = config_dir

    pkg_list = value_for_platform_family(
      'debian' => %w(libpcre3-dev libssl-dev zlib1g-dev),
      'rhel' => %w(pcre-devel openssl-devel zlib-devel)
    )

    pkg_list.each do |pkg|
      package pkg
    end

    download_file_path = ::File.join(Chef::Config[:file_cache_path], "haproxy-#{source_version}.tar.gz")
    remote_file 'haproxy source file' do
      path download_file_path
      source source_url
      checksum source_checksum
      action :create
    end

    make_cmd = "make TARGET=#{source_target_os}"
    make_cmd << " CPU=#{source_target_cpu}" unless source_target_cpu.nil?
    make_cmd << " ARCH=#{source_target_arch}" unless source_target_arch.nil?
    make_cmd << "use_pcre #{use_pcre}"
    make_cmd << "use_openssl #{use_openssl}"
    make_cmd << "use_zlib #{use_zlib}"
    make_cmd << "use_linux_tproxy #{use_linux_tproxy}"
    make_cmd << "use_linux_splice #{use_linux_splice}"

    extra_cmd = ' EXTRA=haproxy-systemd-wrapper' if node['init_package'] == 'systemd'

    bash 'compile_haproxy' do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        tar xzf haproxy-#{source_version}.tar.gz
        cd haproxy-#{source_version}
        #{make_cmd} && make install PREFIX=#{prefix} #{extra_cmd}
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
