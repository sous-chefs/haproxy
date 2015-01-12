actions :create
default_action :create


attribute :name, :kind_of => String, :name_attribute => true
attribute :userlist, :kind_of => String, :required => true
attribute :users, :kind_of => [Array, NilClass], :default => nil
