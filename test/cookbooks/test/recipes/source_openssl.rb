# frozen_string_literal: true

apt_update

if platform_family?('fedora') && node['platform_version'].to_i >= 45
  package %w(gcc make)
else
  build_essential 'compilation tools'
end

# Install dependencies needed by OpenSSL Configure and compilation
case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  if node['platform_version'].to_i >= 9
    package %w(perl-FindBin perl-lib perl-File-Compare perl-File-Copy perl-IPC-Cmd perl-Pod-Html perl-Time-Piece)
  else
    # EL8 bundles perl modules in perl-core, individual packages don't exist
    package 'perl-core' do
      not_if 'perl -MFindBin -Mlib -MFile::Compare -MFile::Copy -MIPC::Cmd -MPod::Html -MTime::Piece -e 1'
    end
    package 'perl-IPC-Cmd'
  end
  package 'zlib-devel'
when 'debian'
  package %w(perl zlib1g-dev)
when 'suse'
  package ['perl', node['platform_version'].to_i >= 16 ? 'zlib-ng-compat-devel' : 'zlib-devel']
end

openssl_version = '3.5.5'

# download openssl
remote_file "#{Chef::Config[:file_cache_path]}/openssl-#{openssl_version}.tar.gz" do
  source "https://github.com/openssl/openssl/releases/download/openssl-#{openssl_version}/openssl-#{openssl_version}.tar.gz"
  checksum 'b28c91532a8b65a1f983b4c28b7488174e4a01008e29ce8e69bd789f28bc2a89'
end

# extract openssl
archive_file 'openssl source' do
  path "#{Chef::Config[:file_cache_path]}/openssl-#{openssl_version}.tar.gz"
  destination "/tmp/openssl-#{openssl_version}"
  strip_components 1
  not_if { ::File.exist?('/usr/local/openssl/bin/openssl') }
end

# compile openssl
execute "package_openssl-#{openssl_version}" do
  command <<-COMPILE
    ./config --prefix=/usr/local/openssl/ --openssldir=/usr/local/openssl/ --libdir=lib shared zlib &&
    make && make install
  COMPILE
  cwd "/tmp/openssl-#{openssl_version}"
  not_if { ::File.exist?('/usr/local/openssl/bin/openssl') }
end

# The HAProxy resource embeds an RPATH for ssl_lib. Keep the custom OpenSSL
# out of the system linker path so distribution tools retain their own ABI.

# renovate: datasource=endoflife-date depName=haproxy versioning=semver
version = '3.2.14'

haproxy_install 'source' do
  source_url "https://www.haproxy.org/download/#{version.to_f}/src/haproxy-#{version}.tar.gz"
  source_checksum 'b21f50a790aa8cb0cf8dc505f1f8d849799eafe4d31c14b86a34409ccf4ae5e4'
  source_version version
  use_openssl true
  use_zlib true
  use_linux_tproxy true
  use_linux_splice true
  use_systemd true
  ssl_lib '/usr/local/openssl/lib'
  ssl_inc '/usr/local/openssl/include'
end
