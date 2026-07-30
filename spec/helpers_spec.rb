# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe Haproxy::Cookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include Haproxy::Cookbook::Helpers

      attr_accessor :node

      def platform_family?(family)
        node['platform_family'] == family
      end

      def platform?(platform)
        node['platform'] == platform
      end

      def platform_version
        node['platform_version']
      end
    end
  end

  let(:helper) { helper_class.new }

  describe '#source_package_list' do
    it 'uses PCRE2 development headers on Debian 13' do
      helper.node = {
        'platform' => 'debian',
        'platform_family' => 'debian',
        'platform_version' => '13',
      }

      expect(helper.source_package_list).to include('libpcre2-dev')
      expect(helper.source_package_list).not_to include('libpcre3-dev')
    end

    it 'uses PCRE2 development headers on RHEL-family version 10' do
      helper.node = {
        'platform' => 'almalinux',
        'platform_family' => 'rhel',
        'platform_version' => '10',
      }

      expect(helper.source_package_list).to include('pcre2-devel')
      expect(helper.source_package_list).not_to include('pcre-devel')
    end
  end

  describe '#target_os' do
    it 'selects the current Linux glibc target' do
      helper.node = {
        'kernel' => {
          'release' => '6.8.0-71-generic',
        },
      }

      expect(helper.target_os('3.2.14')).to eq('linux-glibc')
    end
  end
end
