include Haproxy::Cookbook::Helpers

use 'partial/_config_file'

property :install_type, String,
          name_property: true,
          equal_to: %w(package source)

property :bin_prefix, String,
          default: '/usr'

property :sensitive, [true, false],
          default: true

# Package
property :package_name, String,
          default: 'haproxy'

property :package_version, [String, nil]

property :enable_ius_repo, [true, false],
          default: false

property :enable_epel_repo, [true, false],
          default: true

# Source
property :source_version, String,
          default: '2.2.4'

property :source_url, String,
          default: lazy { "https://www.haproxy.org/download/#{source_version.to_f}/src/haproxy-#{source_version}.tar.gz" }

property :source_checksum, [String, nil],
          default: '87a4d9d4ff8dc3094cb61bbed4a8eed2c40b5ac47b9604daebaf036d7b541be2'

property :source_target_cpu, [String, nil],
          default: lazy { node['kernel']['machine'] }

property :source_target_arch, [String, nil]

property :source_target_os, String,
          default: lazy { target_os(source_version) }

property :use_libcrypt, String,
          equal_to: %w(0 1), default: '1'

property :use_pcre, String,
          equal_to: %w(0 1), default: '1'

property :use_openssl, String,
          equal_to: %w(0 1), default: '1'

property :use_zlib, String,
          equal_to: %w(0 1), default: '1'

property :use_linux_tproxy, String,
          equal_to: %w(0 1), default: '1'

property :use_linux_splice, String,
          equal_to: %w(0 1), default: '1'

property :use_lua, String,
          equal_to: %w(0 1), default: '0'

property :lua_lib, [String, nil]

property :lua_inc, [String, nil]

property :use_systemd, String,
          equal_to: %w(0 1),
          default: lazy { source_version.to_f >= 1.8 ? '1' : '0' }

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action_class do
  include Haproxy::Cookbook::Helpers
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  case new_resource.install_type
  when 'package'
    case node['platform_family']
    when 'amazon'
      include_recipe 'yum-epel' if new_resource.enable_epel_repo
    when 'rhel'
      include_recipe 'yum-epel' if new_resource.enable_epel_repo

      if new_resource.enable_ius_repo && ius_platform_valid?
        puts ius_package[:url]

        remote_file ::File.join(Chef::Config[:file_cache_path], ius_package[:name]) do
          source ius_package[:url]
          only_if { new_resource.enable_ius_repo }
        end

        package ius_package[:name] do
          source ::File.join(Chef::Config[:file_cache_path], ius_package[:name])
          only_if { new_resource.enable_ius_repo }
        end
      else
        log 'This platform is not supported by IUS, ignoring enable_ius_repo property' do
          level :warn
        end
      end
    end

    package new_resource.package_name do
      version new_resource.package_version if new_resource.package_version
    end
  when 'source'
    build_essential 'compilation tools'
    package source_package_list

    remote_file 'haproxy source file' do
      path ::File.join(Chef::Config[:file_cache_path], "haproxy-#{new_resource.source_version}.tar.gz")
      source new_resource.source_url
      checksum new_resource.source_checksum if new_resource.source_checksum
      action :create
    end

    make_cmd = "make TARGET=#{new_resource.source_target_os}"
    make_cmd << " CPU=#{new_resource.source_target_cpu}" unless new_resource.source_target_cpu.nil?
    make_cmd << " ARCH=#{new_resource.source_target_arch}" unless new_resource.source_target_arch.nil?
    make_cmd << " USE_LIBCRYPT=#{new_resource.use_libcrypt}"
    make_cmd << " USE_PCRE=#{new_resource.use_pcre}"
    make_cmd << " USE_OPENSSL=#{new_resource.use_openssl}"
    make_cmd << " USE_ZLIB=#{new_resource.use_zlib}"
    make_cmd << " USE_LINUX_TPROXY=#{new_resource.use_linux_tproxy}"
    make_cmd << " USE_LINUX_SPLICE=#{new_resource.use_linux_splice}"
    make_cmd << " USE_SYSTEMD=#{new_resource.use_systemd}"
    make_cmd << " USE_LUA=#{new_resource.use_lua}" unless new_resource.use_lua == '0'
    make_cmd << " LUA_LIB=#{new_resource.lua_lib}" unless new_resource.lua_lib.nil?
    make_cmd << " LUA_INC=#{new_resource.lua_inc}" unless new_resource.lua_inc.nil?
    extra_cmd = ' EXTRA=haproxy-systemd-wrapper' if new_resource.source_version.to_f < 1.8

    bash 'compile_haproxy' do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        tar xzf haproxy-#{new_resource.source_version}.tar.gz
        cd haproxy-#{new_resource.source_version}
        #{make_cmd} && make install PREFIX=#{new_resource.bin_prefix} #{extra_cmd}
      EOH
      not_if "#{::File.join(new_resource.bin_prefix, 'sbin', 'haproxy')} -v | grep #{new_resource.source_version}"
    end
  end

  with_run_context :root do
    group new_resource.group

    user new_resource.user do
      home "/home/#{new_resource.user}"
      group new_resource.group
    end
  end
end
