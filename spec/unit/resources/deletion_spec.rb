# frozen_string_literal: true

require 'spec_helper'

describe 'HAProxy configuration deletion' do
  platform 'ubuntu', '24.04'
  step_into :haproxy_acl, :haproxy_use_backend, :haproxy_frontend,
            :haproxy_backend, :haproxy_listen, :haproxy_cache,
            :haproxy_fastcgi, :haproxy_mailer, :haproxy_peer,
            :haproxy_resolver, :haproxy_userlist,
            :haproxy_config_global, :haproxy_config_defaults

  %w(backend frontend listen cache fastcgi mailer peer resolver config_global config_defaults).each do |component|
    context "deleting an absent #{component} section" do
      recipe do
        declare_resource("haproxy_#{component}".to_sym, 'missing') do
          action :delete
        end
      end

      it { is_expected.not_to create_directory('/etc/haproxy') }
      it { is_expected.not_to create_template('/etc/haproxy/haproxy.cfg') }
    end
  end

  context 'backend routing in a backend section' do
    recipe do
      haproxy_use_backend 'target if allowed' do
        section 'backend'
        section_name 'source'
      end
    end

    it 'rejects the unsupported section' do
      expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed, /section/)
    end
  end

  %w(frontend listen).each do |section|
    context "backend routing in a #{section} section" do
      recipe do
        declare_resource("haproxy_#{section}".to_sym, 'http') do
          bind '0.0.0.0:80'
        end
        haproxy_use_backend 'target if allowed' do
          section section
          section_name 'http'
        end
      end

      it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('use_backend target if allowed') }
    end
  end

  %w(acl use_backend).each do |component|
    context "deleting an absent #{component}" do
      recipe do
        declare_resource("haproxy_#{component}".to_sym, 'missing') do
          section 'frontend'
          section_name 'missing'
          action :delete
        end
      end

      it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content(/^frontend missing$/) }
      it { is_expected.not_to create_directory('/etc/haproxy') }
      it { is_expected.not_to create_template('/etc/haproxy/haproxy.cfg') }
    end
  end

  {
    backend: 'backend', frontend: 'frontend', listen: 'listen',
    cache: 'cache', fastcgi: 'fcgi-app', mailer: 'mailers',
    peer: 'peers', resolver: 'resolvers',
    config_global: 'global', config_defaults: 'defaults'
  }.each do |component, heading|
    context "deleting a #{component} section" do
      recipe do
        haproxy_userlist 'retained' do
          user 'alice' => 'insecure-password example'
        end
        declare_resource("haproxy_#{component}".to_sym, 'removed') do
          action [:create, :delete]
        end
      end

      it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content(/^#{heading}( removed)?$/) }
      it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('userlist retained') }
    end
  end

  context 'deleting selected rules preserves other frontend rules' do
    recipe do
      haproxy_frontend 'http' do
        bind '0.0.0.0:80'
      end
      haproxy_acl 'keep path_beg /keep' do
        section 'frontend'
        section_name 'http'
      end
      haproxy_acl 'remove path_beg /remove' do
        section 'frontend'
        section_name 'http'
        action [:create, :delete]
      end
      haproxy_use_backend 'keep if keep' do
        section 'frontend'
        section_name 'http'
      end
      haproxy_use_backend 'remove if remove' do
        section 'frontend'
        section_name 'http'
        action [:create, :delete]
      end
    end

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('acl keep path_beg /keep') }
    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('use_backend keep if keep') }
    it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content('acl remove') }
    it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content('use_backend remove') }
  end

  context 'deleting a userlist by name preserves another userlist' do
    recipe do
      haproxy_frontend 'http' do
        bind '0.0.0.0:80'
      end
      haproxy_userlist 'retained' do
        user 'alice' => 'insecure-password example'
      end
      haproxy_userlist 'removed' do
        user 'bob' => 'insecure-password example'
      end
      haproxy_userlist 'removed' do
        action :delete
      end
    end

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content('userlist retained') }
    it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content('userlist removed') }
  end

  context 'deleting an absent userlist' do
    recipe do
      haproxy_userlist 'missing' do
        action :delete
      end
    end

    it { is_expected.not_to create_directory('/etc/haproxy') }
    it { is_expected.not_to create_template('/etc/haproxy/haproxy.cfg') }
  end
end
