build_essential 'compilation tools'

# install lua dependencies
if platform_family?('rhel')
  package %w(
    readline-devel
    ncurses-devel
    pcre-devel
    openssl-devel
    zlib-devel
  )
end

if platform_family?('debian')
  package %w(
    libreadline-dev
    libncurses5-dev
    libpcre3-dev
    libssl-dev
    zlib1g-dev
    liblua5.3-dev
  )
end

# download lua
remote_file "#{Chef::Config[:file_cache_path]}/lua-5.3.1.tar.gz" do
  source 'http://lua.org/ftp/lua-5.3.1.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.exist?('/opt/lua-5.3.1/bin/lua') }
end

# extract lua
execute 'lua extract' do
  command 'tar xf lua-5.3.1.tar.gz'
  cwd "#{Chef::Config[:file_cache_path]}"
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

version = '2.4.25'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum '44b035bdc9ffd4935f5292c2dfd4a1596c048dc59c5b25a0c6d7689d64f50b99'
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
