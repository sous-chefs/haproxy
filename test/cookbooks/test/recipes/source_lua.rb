execute 'dev tools' do
  command 'yum group install -y "Development Tools"'
  action :run
end

package %w(readline-devel)

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

haproxy_install 'source' do
  source_url 'http://www.haproxy.org/download/2.0/src/haproxy-2.0.5.tar.gz'
  source_checksum '3f2e0d40af66dd6df1dc2f6055d3de106ba62836d77b4c2e497a82a4bdbc5422'
  source_version '2.0.5'
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  use_linux_tproxy '1'
  use_linux_splice '1'
  use_lua '1'
  lua_lib '/opt/lua-5.3.1/lib'
  lua_inc '/opt/lua-5.3.1/include'
end
