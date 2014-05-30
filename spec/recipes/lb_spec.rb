require 'spec_helper'

haproxyConfigFile = '/etc/haproxy/haproxy.cfg'

describe 'haproxy::install_package' do
  let(:chef_run) { ChefSpec::Runner.new().converge(described_recipe) }

  it 'Installs the haproxy package' do
    expect(chef_run).to install_package 'haproxy'
  end

  givenVersion = '1.2.3.4'

  # re-converge
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['haproxy']['package']['version'] = givenVersion 
    end.converge(described_recipe)
  end

  it 'Installs the haproxy package at a given version' do
    expect(chef_run).to install_package('haproxy').with_version(givenVersion)
  end

end



