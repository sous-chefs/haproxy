actions :create
default_action :create

def initialize(*args)
  super
  @action = :create

  conf_dir(node["haproxy"]["conf_dir"]) if conf_dir.nil?
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :conf_dir, :kind_of => String, :default => nil