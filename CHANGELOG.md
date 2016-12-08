# haproxy Cookbook CHANGELOG

This file is used to list changes made in each version of the haproxy cookbook.

## v2.0.0 (2016-11-09)

### Breaking Changes

- The default recipe is now an empty recipe with manual configuration performed in the 'manual' recipe
- Remove Chef 10 compatibility code
- Switch from Librarian to Berksfile
- Updated the source recipe to install 1.6.9 by default

### Other changes

- Migrated this cookbook from Heavy Water to Chef Brigade so we can ensure more frequent releases and maintenance
- Added a code of conduct for the project. Read it.
- The haproxy config is now verified before the service restarts / reloads to prevent taking down haproxy with a bad config
- Several new syslog configuration attributes have been added
- A new attribute for stats_socket_level has been added
- A new attribute for retries has been added
- Added a chefignore file to speed up syncs from the server
- Added scientific and oracle as supported platforms in the metadata
- Added source_url, issues_url, and chef_version metadata
- Removed attributes from the metadata file as these are redundant
- Enabled why-run support in the default haproxy resource
- Removed broken tarball validation in the source recipe to prevented installs from completing
- Fixed source installs not running if an older version was present on the node
- Broke search logic out into a new _discovery recipe
- Added new node['haproxy']['pool_members'] and node['haproxy']['pool_members_option'] attributes
- Resolved all cookstyle and foodcritic warnings
- Added a new haproxy_config resource
- Added a Guardfile
- Update the Kitchen config file to use Bento boxes and new platforms
- Updates ChefSpec matchers to use the latest format
- Added testing in Travis CI with a Rakefile that runs cookstyle, foodcritic, and ChefSpec as well as a Kitchen Dokken config that does integration testing of the package install

## v1.6.7

### New Feature

- Added ChefSpec matchers and test coverage

### Updates

- Replaced references to Opscode with Chef

## v1.6.6

### Bug

- CPU Tuning, corrects cpu_affinity resource triggers

### Updates

- parameterize options for admin listener
- renamed templates/rhel to templates/redhat
- sort pool members by hostname to avoid needless restarts
- support amazon linux init script
- support to configure global options

## v1.6.4

## v1.6.2

### Bug

- **[COOK-3424](https://tickets.chef.io/browse/COOK-3424)** - Haproxy cookbook attempts to alter an immutable attribute

### New Feature

- **[COOK-3135](https://tickets.chef.io/browse/COOK-3135)** - Allow setting of members with default recipe without changing the template

## v1.6.2

### Bug

- **[COOK-3424](https://tickets.chef.io/browse/COOK-3424)** - Haproxy cookbook attempts to alter an immutable attribute

### New Feature

- **[COOK-3135](https://tickets.chef.io/browse/COOK-3135)** - Allow setting of members with default recipe without changing the template

## v1.6.0

### New Feature

- Allow setting of members with default recipe without changing the template

## v1.5.0

### Improvement

- **[COOK-3660](https://tickets.chef.io/browse/COOK-3660)** - Make haproxy socket default user group configurable
- **[COOK-3537](https://tickets.chef.io/browse/COOK-3537)** - Add OpenSSL and zlib source configurations

### New Feature

- **[COOK-2384](https://tickets.chef.io/browse/COOK-2384)** - Add LWRP for multiple haproxy sites/configs

## v1.4.0

### Improvement

- **[COOK-3237](https://tickets.chef.io/browse/COOK-3237)** - Enable cookie-based persistence in a backend
- **[COOK-3216](https://tickets.chef.io/browse/COOK-3216)** - Add metadata attributes

### New Feature

- **[COOK-3211](https://tickets.chef.io/browse/COOK-3211)** - Support RHEL
- **[COOK-3133](https://tickets.chef.io/browse/COOK-3133)** - Allow configuration of a global stats socket

## v1.3.2

### Bug

- [COOK-3046]: haproxy default recipe broken by COOK-2656

### Task

- [COOK-2009]: Add test-kitchen support to haproxy

## v1.3.0

### Improvement

- [COOK-2656]: Unify the haproxy.cfg with that from app_lb

### New Feature

- [COOK-1488]: Provide an option to build haproxy from source

## v1.2.0

- [COOK-1936] - use frontend / backend logic
- [COOK-1937] - cleanup for configurations
- [COOK-1938] - more flexibility for options
- [COOK-1939] - reloading haproxy is better than restarting
- [COOK-1940] - haproxy stats listen on 0.0.0.0 by default
- [COOK-1944] - improve haproxy performance

## v1.1.4

- [COOK-1839] - add httpchk configuration to `app_lb` template

## v1.1.0

- [COOK-1275] - haproxy-default.erb should be a cookbook_file
- [COOK-1594] - Template-Service ordering issue in app_lb recipe

## v1.0.6

- [COOK-1310] - redispatch flag has changed

## v1.0.4

- [COOK-806] - load balancer should include an SSL option
- [COOK-805] - Fundamental haproxy load balancer options should be configurable

## v1.0.3

- [COOK-620] haproxy::app_lb's template should use the member cloud private IP by default

## v1.0.2

- fix regression introduced in v1.0.1

## v1.0.1

- account for the case where load balancer is in the pool

## v1.0.0

- Use `node.chef_environment` instead of `node['app_environment']`
