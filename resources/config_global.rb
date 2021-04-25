use 'partial/_config_file'
use 'partial/_extra_options'

property :pidfile, String,
          default: '/var/run/haproxy.pid',
          description: 'Writes PIDs of all daemons into file <pidfile>'

property :log, [String, Array],
          default: '/dev/log syslog info',
          description: 'Adds a global syslog server'

property :daemon, [true, false],
          default: true,
          description: 'Makes the process fork into background'

property :debug_option, String,
          default: 'quiet',
          equal_to: %w(quiet debug),
          description: 'Sets the debugging mode'

property :stats, Hash,
          default: lazy {
                     {
                       socket: "/var/run/haproxy.sock user #{user} group #{group}",
                       timeout: '2m',
                     }
                   },
          description: 'Enable stats with various options'

property :maxconn, [Integer, String],
          default: 4096,
          description: 'Sets the maximum per-process number of concurrent connections'

property :chroot, String,
          description: 'Changes current directory to <jail dir> and performs a chroot() there before dropping privileges'

property :log_tag, String,
          default: 'haproxy',
          description: 'Specifies the log tag to use for all outgoing logs'

property :tuning, Hash,
          description: 'A hash of tune.<options>'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['global'] ||= {}

  haproxy_config_resource.variables['global']['user'] = new_resource.user
  haproxy_config_resource.variables['global']['group'] = new_resource.group
  haproxy_config_resource.variables['global']['pidfile'] = new_resource.pidfile

  haproxy_config_resource.variables['global']['log'] ||= []
  haproxy_config_resource.variables['global']['log'].push(new_resource.log)

  haproxy_config_resource.variables['global']['log_tag'] = new_resource.log_tag
  haproxy_config_resource.variables['global']['chroot'] = new_resource.chroot if property_is_set?(:chroot)
  haproxy_config_resource.variables['global']['daemon'] = new_resource.daemon.to_s
  haproxy_config_resource.variables['global']['debug_option'] = new_resource.debug_option
  haproxy_config_resource.variables['global']['maxconn'] = new_resource.maxconn
  haproxy_config_resource.variables['global']['stats'] = new_resource.stats
  haproxy_config_resource.variables['global']['tuning'] = new_resource.tuning if property_is_set?(:tuning)
  haproxy_config_resource.variables['global']['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end
