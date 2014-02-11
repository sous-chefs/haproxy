# Base attributes used when generating configuration using default LWRP
default[:haproxy][:config][:global][:log]['127.0.0.1'][:local0] = :warn
default[:haproxy][:config][:global][:log]['127.0.0.1'][:local1] = :notice
default[:haproxy][:config][:defaults][:timeout][:client] = '10s'
default[:haproxy][:config][:defaults][:timeout][:client] = '10s'
default[:haproxy][:config][:defaults][:timeout][:server] = '10s'
default[:haproxy][:config][:defaults][:timeout][:connect] = '10s'
default[:haproxy][:config][:defaults][:options] = []
