build_essential 'compilation tools'

# package %w(build-essential zlib1g-dev) if platform_family?('debian')

# Install perl modules for OpenSSL configure script on RHEL/CentOS >= 10
package %w(perl-FindBin perl-lib perl-File-Compare perl-File-Copy perl-IPC-Cmd perl-Pod-Html) if platform_family?('rhel', 'fedora') && node['platform_version'].to_i >= 10

# package %w(make gcc perl pcre-devel zlib-devel perl-core) if platform_family?('rhel')

# override environment variable
ruby_block 'Pre-load OpenSSL path' do
  block do
    ENV['PATH'] = "/usr/local/openssl/bin:#{ENV['PATH']}"
  end
end

openssl_version = '3.2.1'

# download openssl
remote_file "#{Chef::Config[:file_cache_path]}/openssl-#{openssl_version}.tar.gz" do
  source "https://www.openssl.org/source/openssl-#{openssl_version}.tar.gz"
  checksum '83c7329fe52c850677d75e5d0b0ca245309b97e8ecbcfdc1dfdc4ab9fac35b39'
end

# extract openssl
execute "extract_openssl-#{openssl_version}.tar.gz" do
  command "tar -zxf #{Chef::Config[:file_cache_path]}/openssl-#{openssl_version}.tar.gz -C /tmp"
  not_if { ::File.exist?("/tmp/openssl-#{openssl_version}/") }
end

# compile openssl
execute "package_openssl-#{openssl_version}" do
  command <<-COMPILE
    ./config --prefix=/usr/local/openssl/ --openssldir=/usr/local/openssl/ shared zlib
    make
    make install
  COMPILE
  cwd "/tmp/openssl-#{openssl_version}"
  not_if { ::File.exist?('/usr/local/openssl/') }
end

# create symlinks
if rhel?
  # Shared libraries
  file "/etc/ld.so.conf.d/openssl-#{openssl_version}.conf" do
    content '/usr/local/openssl/lib'
    notifies :run, 'execute[reload ldconfig]'
  end

  execute 'reload ldconfig' do
    command 'ldconfig -v'
    action :nothing
  end
end

# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '2.9.3'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum 'ed517c65abd86945411f6bcb18c7ec657a706931cb781ea283063ba0a75858c0'
  source_version version
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
  use_systemd true
  ssl_lib '/usr/local/openssl/lib'
  ssl_inc '/usr/local/openssl/include'
end
