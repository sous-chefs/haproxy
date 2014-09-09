actions :create
default_action :create

def initialize(*args)
  super
  @action = :create

  conf_dir(node["haproxy"]["conf_dir"]) if conf_dir.nil?
  conf_cookbook(node["haproxy"]["conf_cookbook"]) if conf_cookbook.nil?
  conf_template_source(node["haproxy"]["conf_template_source"]) if conf_template_source.nil?
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :conf_dir, :kind_of => String, :default => nil
attribute :conf_cookbook, :kind_of => String, :default => nil
attribute :conf_template_source, :kind_of => String, :default => nil
