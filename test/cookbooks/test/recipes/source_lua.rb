# frozen_string_literal: true

apt_update

build_essential 'compilation tools'

# HAProxy installs its own build dependencies; these are needed by Lua itself.
case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package %w(readline-devel ncurses-devel)
when 'debian'
  package %w(libreadline-dev libncurses-dev)
when 'suse'
  package %w(readline-devel ncurses-devel)
end

# download lua
remote_file "#{Chef::Config[:file_cache_path]}/lua-5.3.1.tar.gz" do
  source 'https://www.lua.org/ftp/lua-5.3.1.tar.gz'
  checksum '072767aad6cc2e62044a66e8562f51770d941e972dc1e4068ba719cd8bffac17'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.exist?('/opt/lua-5.3.1/bin/lua') }
end

# extract lua
archive_file 'lua source' do
  path "#{Chef::Config[:file_cache_path]}/lua-5.3.1.tar.gz"
  destination "#{Chef::Config[:file_cache_path]}/lua-5.3.1"
  strip_components 1
  not_if { ::File.exist?('/opt/lua-5.3.1/bin/lua') }
end

# compile lua
execute 'lua compile' do
  command 'make linux'
  cwd "#{Chef::Config[:file_cache_path]}/lua-5.3.1"
  not_if { ::File.exist?('/opt/lua-5.3.1/bin/lua') }
end

execute 'lua install' do
  command 'make INSTALL_TOP=/opt/lua-5.3.1 install'
  cwd "#{Chef::Config[:file_cache_path]}/lua-5.3.1"
  not_if { ::File.exist?('/opt/lua-5.3.1/bin/lua') }
end

# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '3.2.14'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum 'b21f50a790aa8cb0cf8dc505f1f8d849799eafe4d31c14b86a34409ccf4ae5e4'
  source_version version
  use_pcre true
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
  use_lua true
  lua_lib '/opt/lua-5.3.1/lib'
  lua_inc '/opt/lua-5.3.1/include'
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy' do
  action :create
  delayed_action %i(enable start)
end
