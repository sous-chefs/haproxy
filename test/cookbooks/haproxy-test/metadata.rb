name              "haproxy-test"
maintainer        "Chef Software, Inc."
maintainer_email  "cookbooks@chef.io"
license           "Apache 2.0"
description       "Testing cookbook for haproxy"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

recipe "haproxy", "Install deps for proper testing"

%w{ debian ubuntu centos redhat}.each do |os|
  supports os
end
