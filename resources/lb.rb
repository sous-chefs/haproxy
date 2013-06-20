actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :servers, :kind_of => Array, :default => []
attribute :balance, :kind_of => String
attribute :bind, :kind_of => String, :default => '0.0.0.0:80'
attribute :mode, :kind_of => String, :default => 'http', :equal_to => ['http', 'tcp', 'health']

#I can't think of all parameters available in the future so:
attribute :params, :kind_of => [Array, Hash], :default => []
