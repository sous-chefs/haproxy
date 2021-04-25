property :user, String,
          default: 'haproxy',
          description: 'Set to override default haproxy user, defaults to haproxy'

property :group, String,
          default: 'haproxy',
          description: 'Set to override default haproxy group, defaults to haproxy'

property :config_dir, String,
          default: '/etc/haproxy',
          desired_state: false,
          description: 'Set to override vault configuration directory'

property :config_dir_mode, String,
          default: '0750',
          description: 'Set to override haproxy config dir mode, defaults to 0750'

property :config_file, String,
          default: lazy { ::File.join(config_dir, 'haproxy.cfg') },
          desired_state: false,
          description: 'Set to override vault configuration file, defaults to /etc/{CONFIG_DIR}/haproxy.cfg'

property :config_file_mode, String,
          default: '0640',
          description: 'Set to override default haproxy config file mode, defaults to 0640'

property :cookbook, String,
          default: 'haproxy',
          desired_state: false,
          description: 'Template source cookbook for the haproxy configuration file'

property :template, String,
          default: 'haproxy.cfg.erb',
          desired_state: false,
          description: 'Template source file for the haproxy configuration file'
