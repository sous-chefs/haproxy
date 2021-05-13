module Haproxy
  module Cookbook
    module Helpers
      def haproxy_version
        v = Mixlib::ShellOut.new("haproxy -v | grep version | awk '{ print $3 }'")
        v.run_command.stdout.to_f
      end

      def source_package_list
        case node['platform_family']
        when 'debian'
          %w(libpcre3-dev libssl-dev zlib1g-dev libsystemd-dev)
        when 'rhel', 'amazon', 'fedora'
          %w(pcre-devel openssl-devel zlib-devel systemd-devel)
        when 'suse'
          %w(pcre-devel libopenssl-devel zlib-devel systemd-devel)
        end
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
        if haproxy_version < 1.8
          ::File.join(bin_prefix, 'sbin', 'haproxy-systemd-wrapper')
        else
          ::File.join(bin_prefix, 'sbin', 'haproxy') + ' -Ws'
        end
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
