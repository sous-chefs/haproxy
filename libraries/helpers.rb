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
    end
  end
end
