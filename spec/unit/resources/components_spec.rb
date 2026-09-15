# frozen_string_literal: true

require 'spec_helper'

describe 'HAProxy configuration component resources' do
  step_into :haproxy_acl,
            :haproxy_frontend,
            :haproxy_resolver,
            :haproxy_use_backend,
            :haproxy_userlist

  platform 'ubuntu', '24.04'

  recipe do
    haproxy_frontend 'http' do
      bind '0.0.0.0:80'
    end

    haproxy_acl 'api_path path_beg /api' do
      section 'frontend'
      section_name 'http'
    end

    haproxy_use_backend 'api if api_path' do
      section 'frontend'
      section_name 'http'
    end

    haproxy_resolver 'dns' do
      nameserver ['google 8.8.8.8:53']
    end

    haproxy_userlist 'operators' do
      group('admins' => 'users alice')
      user('alice' => 'insecure-password change-me')
    end
  end

  it do
    is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(
      %r{acl api_path path_beg /api.*use_backend api if api_path}m
    )
  end

  it do
    is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(
      /resolvers dns.*nameserver google 8\.8\.8\.8:53/m
    )
  end

  it do
    is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(
      /userlist operators.*group admins users alice.*user alice insecure-password change-me/m
    )
  end
end
