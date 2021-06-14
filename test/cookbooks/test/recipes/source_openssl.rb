apt_update

if platform_family?('debian')
  if platform_version < 10
    package %w(build-essential checkinstall zlib1g-dev)
  else
    package %w(build-essential zlib1g-dev)
  end
end

if platform_family?('rhel')
  package %w(make gcc perl pcre-devel zlib-devel)
end

# override environment variable
ruby_block 'Pre-load OpenSSL path' do
  block do
    ENV['PATH'] = "/usr/local/openssl/bin:#{ENV['PATH']}"
  end
end

# download openssl
remote_file "#{Chef::Config[:file_cache_path]}/openssl-1.1.1h.tar.gz" do
  source 'https://www.openssl.org/source/openssl-1.1.1h.tar.gz'
  checksum '5c9ca8774bd7b03e5784f26ae9e9e6d749c9da2438545077e6b3d755a06595d9'
end

# extract openssl
execute 'extract_openssl-1.1.1h.tar.gz' do
  command "tar -zxf #{Chef::Config[:file_cache_path]}/openssl-1.1.1h.tar.gz -C /tmp"
  not_if { ::File.exist?('/tmp/openssl-1.1.1h/') }
end

# complie openssl
execute 'package_openssl-1.1.1h' do
  command <<-COMPILE
    ./config --prefix=/usr/local/openssl/ --openssldir=/usr/local/openssl/ shared zlib
    make
    make install
  COMPILE
  cwd '/tmp/openssl-1.1.1h'
  not_if { ::File.exist?('/usr/local/openssl/') }
end

# Legacy OpenSSL replacement
if (rhel? && (platform_version < 8)) || (debian? && (platform_version < 10))
  # Shared libraries
  file '/etc/ld.so.conf.d/openssl-1.1.1h.conf' do
    content '/usr/local/openssl/lib'
    notifies :run, 'execute[reload ldconfig]'
  end

  execute 'reload ldconfig' do
    command 'ldconfig -v'
    action :nothing
  end

  # Remove old binary, link to new
  file '/usr/bin/openssl' do
    action :nothing
  end

  link '/usr/bin/openssl' do
    to '/usr/local/openssl/bin/openssl'
    link_type :symbolic
    notifies :delete, 'file[/usr/bin/openssl]', :before
  end
end

# install haproxy with openssl
haproxy_install 'source' do
  source_url 'http://www.haproxy.org/download/2.2/src/haproxy-2.2.4.tar.gz'
  source_checksum '87a4d9d4ff8dc3094cb61bbed4a8eed2c40b5ac47b9604daebaf036d7b541be2'
  source_version '2.2.4'
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
  use_systemd true
  ssl_lib '/usr/local/openssl/lib'
  ssl_inc '/usr/local/openssl/include'
end
