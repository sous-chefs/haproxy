class Chef
  module Haproxy
    module Helpers
      def haproxy_version
        v = Mixlib::ShellOut.new("haproxy -v | grep version | awk '{ print $3 }'")
        v.run_command.stdout.to_f
      end

      def systemd_command(bin_prefix)
        if haproxy_version < 1.8
          ::File.join(bin_prefix, 'sbin', 'haproxy-systemd-wrapper')
        else
          ::File.join(bin_prefix, 'sbin', 'haproxy') + ' -Ws'
        end
      end

      def source_package_list
        case node['platform_family']
        when 'debian', 'ubuntu'
          %w(libpcre3-dev libssl-dev zlib1g-dev libsystemd-dev)
        when 'rhel', 'amazon'
          %w(pcre-devel openssl-devel zlib-devel systemd-devel)
        when 'suse'
          %w(pcre-devel libopenssl-devel zlib-devel systemd-devel)
        end
      end

      def ius_package
        {
          name: 'ius-release.rpm',
          url: "https://#{node['platform']}#{node['platform_version'].to_i}.iuscommunity.org/ius-release.rpm",
        }
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
    end
  end
end
