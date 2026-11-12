# frozen_string_literal: true

module Haproxy
  module Cookbook
    module Helpers
      def pcre_package_name
        # Use PCRE2 for RHEL/CentOS/AlmaLinux/Rocky >= 10 where PCRE1 is deprecated
        # Fedora 45 also removes PCRE1 from its package repositories.
        if (platform_family?('rhel') && platform_version.to_i >= 10) ||
           (platform_family?('fedora') && platform_version.to_i >= 45)
          'pcre2-devel'
        else
          'pcre-devel'
        end
      end

      def debian_pcre_package_name
        if (platform?('debian') && platform_version.to_i >= 13) ||
           (platform?('ubuntu') && platform_version.to_f >= 26.04)
          'libpcre2-dev'
        else
          'libpcre3-dev'
        end
      end

      def source_package_list
        case node['platform_family']
        when 'debian'
          [debian_pcre_package_name, 'libssl-dev', 'zlib1g-dev', 'libsystemd-dev']
        when 'rhel', 'amazon', 'fedora'
          [pcre_package_name, openssl_package_name, 'zlib-devel', 'systemd-devel', 'tar']
        when 'suse'
          ['pcre-devel', 'libopenssl-devel', suse_zlib_package_name, 'systemd-devel']
        end
      end

      def openssl_package_name
        platform_family?('fedora') && platform_version.to_i >= 45 ? 'openssl3-devel' : 'openssl-devel'
      end

      def suse_zlib_package_name
        platform_version.to_i >= 16 ? 'zlib-ng-compat-devel' : 'zlib-devel'
      end

      def ius_package
        {
          name: 'ius-release.rpm',
          url: 'https://repo.ius.io/ius-release-el7.rpm',
        }
      end

      def ius_platform_valid?
        platform_family?('rhel') && (platform_version.to_i == 6 || platform_version.to_i == 7)
      end

      def target_os(source_version)
        major_revision = node['kernel']['release'].split('.')[0..1].join('.').to_f
        minor_revision = node['kernel']['release'].split('.')[2].split('-').first.to_i

        if major_revision > 2.6
          source_version.chars.first == '1' ? 'linux2628' : 'linux-glibc'
        elsif major_revision == 2.6
          if minor_revision >= 28
            source_version.chars.first == '1' ? 'linux2628' : 'linux-glibc'
          else
            'linux26'
          end
        else
          'generic'
        end
      end

      def systemd_command(bin_prefix)
        ::File.join(bin_prefix, 'sbin', 'haproxy') + ' -Ws'
      end

      def default_systemd_unit_content
        {
          'Unit' => {
            'Description' => 'HAProxy Load Balancer',
            'Documentation' => 'file:/usr/share/doc/haproxy/configuration.txt.gz',
            'After' => %w(network.target syslog.service),
          },
          'Service' => {
            'EnvironmentFile' => '-/etc/default/haproxy',
            'Environment' => "CONFIG=#{config_file} PIDFILE=/run/haproxy.pid",
            'ExecStartPre' => "#{bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
            'ExecStart' => "#{systemd_command(bin_prefix)} -f $CONFIG -p $PIDFILE $OPTIONS",
            'ExecReload' => [
              "#{bin_prefix}/sbin/haproxy -f $CONFIG -c -q",
              '/bin/kill -USR2 $MAINPID',
            ],
            'KillSignal' => 'TERM',
            'User' => 'root',
            'WorkingDirectory' => '/',
            'KillMode' => 'mixed',
            'Restart' => 'always',
          },
          'Install' => {
            'WantedBy' => 'multi-user.target',
          },
        }
      end
    end
  end
end
