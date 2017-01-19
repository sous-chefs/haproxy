require 'spec_helper'

describe 'haproxy::install_source' do
  let(:given_version) { '1.2.3.4' }
  let(:source_path) { ::File.join(Chef::Config[:file_cache_path], "haproxy-#{given_version}.tar.gz") }

  before do
    stub_command('/usr/local/sbin/haproxy -v | grep 1.2.3.4').and_return(false)
  end

  platform_packages = {
    'ubuntu' => {
      'packages' => [
        'libpcre3-dev',
        'libssl-dev',
        'zlib1g-dev',
      ],
    },
    'centos' => {
      'packages' => [
        'pcre-devel',
        'openssl-devel',
        'zlib-devel',
      ],
    },
  }

  platforms = {
    'ubuntu' => {
      'platform' => 'ubuntu',
      'versions' => ['16.04'],
    },
    'centos' => {
      'platform' => 'centos',
      'versions' => ['6.7'],
    },
  }

  platforms.each do |platform_name, platform|
    platform['versions'].each do |platform_version|
      context "on #{platform_name} #{platform_version}" do
        let(:chef_run) do
          runner = ChefSpec::ServerRunner.new(
            platform: platform_name,
            version: platform_version
          )

          runner.node.normal['haproxy']['source']['version'] = given_version
          runner.converge(described_recipe)
        end

        platform_packages[platform['platform']]['packages'].each do |package|
          it "does not include the package #{package}" do
            expect(chef_run).to_not install_package(package)
          end
        end

        it 'includes the external build-essential recipe' do
          expect(chef_run).to include_recipe('build-essential')
        end

        it 'downloads the haproxy source' do
          expect(chef_run).to create_remote_file('haproxy source file')
        end

        it 'compiles haproxy' do
          expect(chef_run).to run_bash('compile_haproxy')
        end

        it 'creates the haproxy conf directory' do
          expect(chef_run).to create_directory('/usr/local/etc/haproxy')
        end
      end
    end
  end
end
