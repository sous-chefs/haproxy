require 'spec_helper'

describe 'Default recipe on Ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['haproxy_install']) }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
