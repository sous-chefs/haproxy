haproxy Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the haproxy cookbook.


v1.6.2
------
### Bug
- **[COOK-3424](https://tickets.opscode.com/browse/COOK-3424)** - Haproxy cookbook attempts to alter an immutable attribute

### New Feature
- **[COOK-3135](https://tickets.opscode.com/browse/COOK-3135)** - Allow setting of members with default recipe without changing the template


v1.6.2
------
### Bug
- **[COOK-3424](https://tickets.opscode.com/browse/COOK-3424)** - Haproxy cookbook attempts to alter an immutable attribute

### New Feature
- **[COOK-3135](https://tickets.opscode.com/browse/COOK-3135)** - Allow setting of members with default recipe without changing the template


v1.6.0
------
### New Feature
- Allow setting of members with default recipe without changing the template


v1.5.0
------
### Improvement
- **[COOK-3660](https://tickets.opscode.com/browse/COOK-3660)** - Make haproxy socket default user group configurable
- **[COOK-3537](https://tickets.opscode.com/browse/COOK-3537)** - Add OpenSSL and zlib source configurations

### New Feature
- **[COOK-2384](https://tickets.opscode.com/browse/COOK-2384)** - Add LWRP for multiple haproxy sites/configs

v1.4.0
------
### Improvement
- **[COOK-3237](https://tickets.opscode.com/browse/COOK-3237)** - Enable cookie-based persistence in a backend
- **[COOK-3216](https://tickets.opscode.com/browse/COOK-3216)** - Add metadata attributes

### New Feature
- **[COOK-3211](https://tickets.opscode.com/browse/COOK-3211)** - Support RHEL
- **[COOK-3133](https://tickets.opscode.com/browse/COOK-3133)** - Allow configuration of a global stats socket

v1.3.2
------
### Bug
- [COOK-3046]: haproxy default recipe broken by COOK-2656

### Task
- [COOK-2009]: Add test-kitchen support to haproxy

v1.3.0
------
### Improvement
- [COOK-2656]: Unify the haproxy.cfg with that from app_lb

### New Feature
- [COOK-1488]: Provide an option to build haproxy from source

v1.2.0
------
- [COOK-1936] - use frontend / backend logic
- [COOK-1937] - cleanup for configurations
- [COOK-1938] - more flexibility for options
- [COOK-1939] - reloading haproxy is better than restarting
- [COOK-1940] - haproxy stats listen on 0.0.0.0 by default
- [COOK-1944] - improve haproxy performance

v1.1.4
------
- [COOK-1839] - add httpchk configuration to `app_lb` template

v1.1.0
------
- [COOK-1275] - haproxy-default.erb should be a cookbook_file
- [COOK-1594] - Template-Service ordering issue in app_lb recipe

v1.0.6
------
- [COOK-1310] - redispatch flag has changed

v1.0.4
------
- [COOK-806] - load balancer should include an SSL option
- [COOK-805] - Fundamental haproxy load balancer options should be configurable

v1.0.3
------
- [COOK-620] haproxy::app_lb's template should use the member cloud private IP by default

v1.0.2
------
- fix regression introduced in v1.0.1

v1.0.1
------
- account for the case where load balancer is in the pool

v1.0.0
------
- Use `node.chef_environment` instead of `node['app_environment']`
