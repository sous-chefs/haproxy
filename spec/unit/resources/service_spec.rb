# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy_service' do
  step_into :haproxy_service
  platform 'ubuntu', '24.04'

  context 'with action :create' do
    recipe do
      haproxy_service 'haproxy' do
        action :create
      end
    end

    it do
      is_expected.to create_file('/etc/default/haproxy').with(
        content: '',
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it { is_expected.to create_systemd_unit('haproxy.service') }
  end

  context 'with action :delete' do
    recipe do
      haproxy_service 'haproxy' do
        action :delete
      end
    end

    it { is_expected.to delete_file('/etc/default/haproxy') }
    it { is_expected.to delete_systemd_unit('haproxy.service') }
  end

  context 'with action :start and configuration testing disabled' do
    recipe do
      haproxy_service 'haproxy' do
        config_test false
        action :start
      end
    end

    it { is_expected.to start_systemd_unit('haproxy.service') }
  end
end
