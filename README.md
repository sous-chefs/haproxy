# haproxy Cookbook

[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/haproxy/master.svg)](https://circleci.com/gh/sous-chefs/haproxy) [![Cookbook Version](https://img.shields.io/cookbook/v/haproxy.svg)](https://supermarket.chef.io/cookbooks/haproxy)

Installs and configures HAProxy.

## Requirements

* HAProxy `stable` or `LTS`
* Chef 13+

### Platforms

This cookbook officially supports and is tested against the following platforms:

* debian: 8 & 9
* ubuntu: 16.04 & 18.04
* centos: 7
* amazonlinux: 1 & 2
* opensuseleap: 15

PRs are welcome to add support for additional platforms.

### Examples

Please check for working examples in [TEST](./test/fixtures/cookbooks/test/)

## Common Resource Features

HAProxy has many configurable options available, this cookbook makes the most popular options available as resource properties.

If you wish to use a HAProxy property that is not listed the `extra_options` hash is available to take in any number of additional values.

For example, the ability to disable listeners is not provided out of the box. Further examples can be found in either `test/fixtures/recipes` or `spec/test/recipes`. If you have questions on how this works or would like to add more examples so it is easier to understand, please come talk to us on the [Chef Community Slack](http://community-slack.chef.io/) on the #sous-chefs channel.

```ruby
haproxy_listen 'disabled' do
  bind '0.0.0.0:1337'
  mode 'http'
  extra_options('disabled': '')
end
```

The `extra_options` hash is of `String => String` or `String => Array`. When an `Array` value is provided. The values are looped over mapping the key to each value in the config.

For example:

```ruby
haproxy_listen 'default' do
  extra_options(
    'http-request' => [ 'set-header X-Public-User yes', 'del-header X-Bad-Header' ]
    )
end
```

Becomes:

```
listen default
  ...
  http-request set-header X-Public-User yes
  http-request del-header X-Bad-Header
```

## Resources

* [haproxy_acl](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_acl.md)
* [haproxy_backend](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_backend.md)
* [haproxy_cache](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_cache.md)
* [haproxy_config_defaults](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_config_defaults.md)
* [haproxy_config_global](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_config_global.md)
* [haproxy_frontend](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_frontend.md)
* [haproxy_install](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_install.md)
* [haproxy_listen](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_listen.md)
* [haproxy_resolver](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_resolver.md)
* [haproxy_service](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_service.md)
* [haproxy_use_backend](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_use_backend.md)
* [haproxy_userlist](https://github.com/sous-chefs/haproxy/tree/master/documentation/haproxy_userlist.md)

## Configuration Validation

The `haproxy.cfg` file has a few specific rule orderings that will generate validation errors if not loaded properly. If using any combination of the below rules, avoid the errors by loading the rules via `extra_options` to specify the top down order as noted below in config file.

### frontend & listen

```
  tcp-request connection
  tcp-request session
  tcp-request content
  monitor fail
  block (deprecated)
  http-request
  reqxxx (any req excluding reqadd, e.g. reqdeny, reqallow)
  reqadd
  redirect
  use_backend
```

```ruby
  extra_options(
    'tcp-request' => 'connection set-src src,ipmask(24)',
    'reqdeny' => '^Host:\ .*\.local',
    'reqallow' => '^Host:\ www\.',
    'use_backend' => 'dynamic'
  )
```

### backend

```
  http-request
  reqxxx (any req excluding reqadd, e.g. reqdeny, reqallow)
  reqadd
  redirect
```

```ruby
  extra_options(
    'http-request' => 'set-path /%[hdr(host)]%[path]',
    'reqdeny' => '^Host:\ .*\.local',
    'reqallow' => '^Host:\ www\.',
    'redirect' => 'dynamic'
  )
```

## License & Authors

* Author:: Dan Webb (<https://github.com/damacus>)
* Author:: Will Fisher (<https://github.com/teknofire>)
* Author:: Richard Shade (<https://github.com/rshade>)
* Author:: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
* Author:: Aaron Baer ([aaron@hw-ops.com](mailto:aaron@hw-ops.com))
* Author:: Justin Kolberg ([justin@hw-ops.com](mailto:justin@hw-ops.com))

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
