require 'spec_helper'

describe 'haproxy::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  it 'runs no tests' do
    expect(chef_run)
  end
end
