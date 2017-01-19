require 'spec_helper'

describe 'haproxy::manual' do
  cached(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'includes the haproxy defaults file' do
    expect(chef_run).to create_cookbook_file('/etc/default/haproxy').with(
      source: 'haproxy-default',
      owner: 'root',
      group: 'root',
      mode: '0644'
    )
  end

  it 'creates the admin lb entry' do
    expect(chef_run).to create_haproxy_lb('admin')
  end

  it 'creates the http lb entry' do
    expect(chef_run).to create_haproxy_lb('http')
  end

  it 'creates the servers-http lb entry' do
    expect(chef_run).to create_haproxy_lb('servers-http')
  end

  it 'writes out the haproxy config' do
    expect(chef_run).to create_haproxy_config('Create haproxy.cfg')
  end
end
