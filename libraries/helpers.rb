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
    end
  end
end
