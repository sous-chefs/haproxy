## v1.2.0:

* [COOK-1936] - use frontend / backend logic
* [COOK-1937] - cleanup for configurations
* [COOK-1938] - more flexibility for options
* [COOK-1939] - reloading haproxy is better than restarting
* [COOK-1940] - haproxy stats listen on 0.0.0.0 by default
* [COOK-1944] - improve haproxy performance

## v1.1.4:

* [COOK-1839] - add httpchk configuration to `app_lb` template

## v1.1.0:

* [COOK-1275] - haproxy-default.erb should be a cookbook_file
* [COOK-1594] - Template-Service ordering issue in app_lb recipe

## v1.0.6:

* [COOK-1310] - redispatch flag has changed

## v1.0.4:

* [COOK-806] - load balancer should include an SSL option
* [COOK-805] - Fundamental haproxy load balancer options should be configurable

## v1.0.3:

* [COOK-620] haproxy::app_lb's template should use the member cloud private IP by default

## v1.0.2:

* fix regression introduced in v1.0.1

## v1.0.1:

* account for the case where load balancer is in the pool

## v1.0.0:

* Use `node.chef_environment` instead of `node['app_environment']`
