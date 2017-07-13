# haproxy Cookbook

[![Build Status](https://travis-ci.org/sous-chefs/haproxy.svg?branch=master)](https://travis-ci.org/sous-chefs/haproxy) [![Cookbook Version](https://img.shields.io/cookbook/v/haproxy.svg)](https://supermarket.chef.io/cookbooks/haproxy)

Installs and configures haproxy.

## Requirements

- Chef 12.5+

### Platforms

- Ubuntu 12.04+, Ubuntu 14.04+, Ubuntu 16.04
- RHEL 6+, CentOS6+, OracleLinux6+
- RHEL 7+, CentOS7+, OracleLinux7+
- Debian 8+

## Resources

### Install

```ruby
haproxy_install 'package' do

end
```

```ruby
haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end
```

```ruby
haproxy_config_defaults '' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
end
```

```ruby
haproxy_frontend 'http-in' do
  bind '*:80'
  extra_options(
    'redirect' => [
      'code 301 prefix / if acl1',
      'scheme https if !acl_2'
    ])
  default_backend 'servers'
end
```

```ruby
haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end
```

### Resolver

```ruby
haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
end
```

## License & Authors

- Author:: Dan Webb ([https://github.com/damacus](https://github.com/damacus))
- Author:: Will Fisher ([https://github.com/teknofire](https://github.com/teknofire))
- Author:: Richard Shade ([https://github.com/rshade](https://github.com/rshade))
- Author:: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
- Author:: Aaron Baer ([aaron@hw-ops.com](mailto:aaron@hw-ops.com))
- Author:: Justin Kolberg ([justin@hw-ops.com](mailto:justin@hw-ops.com))

```text
Copyright:: Heavy Water Operations, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
