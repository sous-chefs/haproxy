name              "haproxy"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures haproxy"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.4.0"

recipe "haproxy", "Installs and configures haproxy"
recipe "haproxy::app_lb", "Installs and configures haproxy by searching for nodes of a particular role"

%w{ debian ubuntu centos redhat}.each do |os|
  supports os
end

depends           "cpu", ">= 0.2.0"
depends           "build-essential"

attribute "haproxy/incoming_address",
  :display_name => "HAProxy incoming address",
  :description => "Sets the address to bind the haproxy process on, 0.0.0.0 (all addresses) by default.",
  :required => "optional",
  :default => "0.0.0.0"

attribute "haproxy/incoming_port",
  :display_name => "HAProxy incoming port",
  :description => "Sets the port on which haproxy listens.",
  :required => "optional",
  :default => "80"

attribute "haproxy/member_port",
  :display_name => "HAProxy member port",
  :description => "The port that member systems will be listening on, default 8080.",
  :required => "optional",
  :default => "8080"

attribute "haproxy/app_server_role",
  :display_name => "HAProxy app server role",
  :description => "Used by the app_lb recipe to search for a specific role of member systems. Default webserver.",
  :required => "optional",
  :default => "webserver"

attribute "haproxy/balance_algorithm",
  :display_name => "HAProxy balance algorithm",
  :description => "Sets the load balancing algorithm; defaults to roundrobin.",
  :required => "optional",
  :default => "roundrobin"

attribute "haproxy/enable_ssl",
  :display_name => "HAProxy enable ssl",
  :description => "Whether or not to create listeners for ssl, default false.",
  :required => "optional"

attribute "haproxy/ssl_incoming_address",
  :display_name => "HAProxy ssl incoming address",
  :description => "Sets the address to bind the haproxy on for SSL, 0.0.0.0 (all addresses) by default.",
  :required => "optional",
  :default => "0.0.0.0"

attribute "haproxy/ssl_member_port",
  :display_name => "HAProxy member port",
  :description => "The port that member systems will be listening on for ssl, default 8443.",
  :required => "optional",
  :default => "8443"

attribute "haproxy/ssl_incoming_port",
  :display_name => "HAProxy incoming port",
  :description => "Sets the port on which haproxy listens for ssl, default 443.",
  :required => "optional",
  :default => "443"

attribute "haproxy/httpchk",
  :display_name => "HAProxy HTTP health check",
  :description => "Used by the haproxy::app_lb recipe. If set, will configure httpchk in haproxy.conf.",
  :required => "optional"

attribute "haproxy/ssl_httpchk",
  :display_name => "HAProxy SSL HTTP health check",
  :description => "Used by the app_lb recipe. If set and enable_ssl is true, will configure httpchk in haproxy.conf for the ssl_application section.",
  :required => "optional"

attribute "haproxy/enable_admin",
  :display_name => "HAProxy enable admin",
  :description => "Whether to enable the admin interface. default true. Listens on port 22002.",
  :required => "optional",
  :default => "true"

attribute "haproxy/admin/address_bind",
  :display_name => "HAProxy admin address bind",
  :description => "Sets the address to bind the administrative interface on, 127.0.0.1 by default.",
  :required => "optional",
  :default => "127.0.0.1"

attribute "haproxy/admin/port",
  :display_name => "HAProxy admin port",
  :description => "Sets the port for the administrative interface, 22002 by default.",
  :required => "optional",
  :default => "22002"

attribute "haproxy/pid_file",
  :display_name => "HAProxy PID file",
  :description => "The PID file of the haproxy process, used in the tuning recipe.",
  :required => "optional",
  :default => "/var/run/haproxy.pid"

attribute "haproxy/default options",
  :display_name => "HAProxy default options",
  :description => "An array of options to use for the config file's defaults stanza, default is [\"httplog\", \"dontlognull\", \"redispatch\"].",
  :required => "optional",
  :type => "array",
  :default => ["httplog", "dontlognull", "redispatch"]

attribute "haproxy/defaults_timeouts/connect",
  :display_name => "HAProxy connect timeout",
  :description => "Connect timeout in defaults stanza.",
  :required => "optional",
  :default => "5s"

attribute "haproxy/defaults_timeouts/client",
  :display_name => "HAProxy client timeout",
  :description => "Client timeout in defaults stanza.",
  :required => "optional",
  :default => "50s"

attribute "haproxy/defaults_timeouts/server",
  :display_name => "HAProxy server timeout",
  :description => "Server timeout in defaults stanza.",
  :required => "optional",
  :default => "50s"

attribute "haproxy/x_forwarded_for",
  :display_name => "HAProxy X-Forwarded-For",
  :description => "If true, creates an X-Forwarded-For header containing the original client's IP address. This option disables KeepAlive.",
  :required => "optional"

attribute "haproxy/member_max_connections",
  :display_name => "HAProxy member max connections",
  :description => "The maxconn value to be set for each app server.",
  :required => "optional",
  :default => "100"

attribute "haproxy/user",
  :display_name => "HAProxy user",
  :description => "User that haproxy runs as.",
  :required => "optional",
  :default => "haproxy"

attribute "haproxy/group",
  :display_name => "HAProxy group",
  :description => "Group that haproxy runs as.",
  :required => "optional",
  :default => "haproxy"

attribute "haproxy/global_max_connections",
  :display_name => "HAProxy global max connections",
  :description => "In the app_lb config, set the global maxconn.",
  :required => "optional",
  :default => "4096"

attribute "haproxy/frontend_max_connections",
  :display_name => "HAProxy frontend max connections",
  :description => "In the app_lb config, set the the maxconn per frontend member.",
  :required => "optional",
  :default => "2000"

attribute "haproxy/frontend_ssl_max_connections",
  :display_name => "HAProxy frontend SSL max connections",
  :description => "In the app_lb config, set the maxconn per frontend member using SSL.",
  :required => "optional",
  :default => "2000"

attribute "haproxy/install_method",
  :display_name => "HAProxy install method",
  :description => "Determines which method is used to install haproxy, must be 'source' or 'package'. defaults to 'package'.",
  :required => "recommended",
  :choice => ["package", "source"],
  :default => "package"

attribute "haproxy/conf_dir",
  :display_name => "HAProxy config directory",
  :description => "The location of the haproxy config file.",
  :required => "optional",
  :default => "/etc/haproxy"

attribute "haproxy/source/version",
  :display_name => "HAProxy source version",
  :description => "The version of haproxy to install.",
  :required => "optional",
  :default => "1.4.22"

attribute "haproxy/source/url",
  :display_name => "HAProxy source URL",
  :description => "The full URL to the haproxy source package.",
  :required => "optional",
  :default => "http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.22.tar.gz"

attribute "haproxy/source/checksum",
  :display_name => "HAProxy source checksum",
  :description => "The checksum of the haproxy source package.",
  :required => "optional",
  :default => "ba221b3eaa4d71233230b156c3000f5c2bd4dace94d9266235517fe42f917fc6"

attribute "haproxy/source/prefix",
  :display_name => "HAProxy source prefix",
  :description => "The prefix used to make install haproxy.",
  :required => "optional",
  :default => "/usr/local"

attribute "haproxy/source/target_os",
  :display_name => "HAProxy source target OS",
  :description => "The target used to make haproxy.",
  :required => "optional",
  :default => "generic"

attribute "haproxy/source/target_cpu",
  :display_name => "HAProxy source target CPU",
  :description => "The target cpu used to make haproxy.",
  :required => "optional",
  :default => ""

attribute "haproxy/source/target_arch",
  :display_name => "HAProxy source target arch",
  :description => "The target arch used to make haproxy.",
  :required => "optional",
  :default => ""

attribute "haproxy/source/use_pcre",
  :display_name => "HAProxy source use PCRE",
  :description => "Whether to build with libpcre support.",
  :required => "optional"
