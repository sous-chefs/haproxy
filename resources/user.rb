actions :create
default_action :create


attribute :username, :kind_of => String, :name_attribute => true
attribute :groups, :kind_of => [Array, NilClass], :default => nil
attribute :insecure_password, :kind_of => [FalseClass, TrueClass], :default => false
attribute :password, :kind_of => String, :required => true
attribute :userlist, :kind_of => String, :required => true
