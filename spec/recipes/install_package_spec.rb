require 'spec_helper'

describe 'haproxy::install_package' do
  cached(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs the haproxy package' do
    expect(chef_run).to install_package 'haproxy'
  end

  it 'creates the haproxy conf directory' do
    expect(chef_run).to create_directory('/etc/haproxy')
  end

  describe 'with version set' do
    let(:given_version) { '1.2.3.4' }
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.normal['haproxy']['package']['version'] = given_version
      end.converge(described_recipe)
    end

    it 'installs the haproxy package at a given version' do
      expect(chef_run).to install_package('haproxy').with_version(given_version)
    end
  end
end
