actions :create
default_action :create

attribute :name, kind_of: String, name_attribute: true
attribute :conf_dir, kind_of: String, default: lazy { node['haproxy']['conf_dir'] }
attribute :conf_cookbook, kind_of: String, default: lazy { node['haproxy']['conf_cookbook'] }
attribute :conf_template_source, kind_of: String, default: lazy { node['haproxy']['conf_template_source'] }
