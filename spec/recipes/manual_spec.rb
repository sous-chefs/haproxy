require 'spec_helper'

describe 'haproxy::manual' do
  let(:chef_run) { ChefSpec::Runner.new().converge(described_recipe) }

  it 'includes the haproxy defaults file' do
    expect(chef_run).to create_cookbook_file('/etc/default/haproxy').with(
      source: 'haproxy-default',
      owner: 'root',
      group: 'root',
      mode: 00644,
    )
  end

  it 'creates the haproxy user' do
    expect(chef_run).to create_user('haproxy')
  end

  it 'creates the haproxy group' do
    expect(chef_run).to create_group('haproxy')
    .with(members: %w(haproxy))
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

  it 'enables the haproxy service' do
    expect(chef_run).to enable_service('haproxy')
  end

  it 'starts the haproxy service' do
    expect(chef_run).to start_service('haproxy')
  end
end
