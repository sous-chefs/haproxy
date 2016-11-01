require 'spec_helper'

describe 'haproxy::install_package' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the haproxy package' do
    expect(chef_run).to install_package 'haproxy'
  end

  it 'creates the haproxy conf directory' do
    expect(chef_run).to create_directory('/etc/haproxy')
  end

  it 'creates the haproxy init.d script' do
    expect(chef_run).to create_template('/etc/init.d/haproxy').with(
      source: 'haproxy-init.erb',
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
  end

  describe 'with version set' do
    let(:given_version) { '1.2.3.4' }
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['haproxy']['package']['version'] = given_version
      end.converge(described_recipe)
    end

    it 'installs the haproxy package at a given version' do
      expect(chef_run).to install_package('haproxy').with_version(given_version)
    end
  end
end
