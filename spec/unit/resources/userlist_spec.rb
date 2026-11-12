# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy_userlist' do
  platform 'ubuntu', '24.04'
  step_into :haproxy_userlist

  context 'when it is the first configuration resource' do
    recipe do
      haproxy_userlist 'operators' do
        user 'alice' => 'insecure-password example'
        group 'admins' => 'users alice'
      end
    end

    it { is_expected.to create_directory('/etc/haproxy').with(owner: 'haproxy', group: 'haproxy') }
    it { is_expected.to create_template('/etc/haproxy/haproxy.cfg').with(owner: 'haproxy', group: 'haproxy') }
    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('user alice insecure-password example') }
  end

  context 'with explicit configuration ownership' do
    recipe do
      haproxy_userlist 'operators' do
        config_owner 'root'
        config_group 'root'
        user 'alice' => 'insecure-password example'
      end
    end

    it { is_expected.to create_directory('/etc/haproxy').with(owner: 'root', group: 'root') }
    it { is_expected.to create_template('/etc/haproxy/haproxy.cfg').with(owner: 'root', group: 'root') }
  end
end
