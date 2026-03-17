apt_update

build_essential 'compilation tools'

# Install dependencies needed by OpenSSL Configure and compilation
case node['platform_family']
when 'rhel', 'fedora'
  if node['platform_version'].to_i >= 9
    package %w(perl-FindBin perl-lib perl-File-Compare perl-File-Copy perl-IPC-Cmd perl-Pod-Html perl-Time-Piece)
  else
    # EL8 bundles perl modules in perl-core, individual packages don't exist
    package %w(perl-core perl-IPC-Cmd)
  end
when 'debian'
  package %w(perl zlib1g-dev)
when 'suse'
  package %w(perl zlib-devel)
end

# override environment variable
ruby_block 'Pre-load OpenSSL path' do
  block do
    ENV['PATH'] = "/usr/local/openssl/bin:#{ENV['PATH']}"
  end
end

openssl_version = '3.5.5'

# download openssl
remote_file "#{Chef::Config[:file_cache_path]}/openssl-#{openssl_version}.tar.gz" do
  source "https://github.com/openssl/openssl/releases/download/openssl-#{openssl_version}/openssl-#{openssl_version}.tar.gz"
  checksum 'b28c91532a8b65a1f983b4c28b7488174e4a01008e29ce8e69bd789f28bc2a89'
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
