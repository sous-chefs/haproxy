actions :create
default_action :create


attribute :name, :kind_of => String, :name_attribute => true
attribute :type, :kind_of => String, :default => 'listen', :equal_to => ['listen', 'backend', 'frontend']

#Defining some attributes, but they can be all nil and defined in params
#if convenient.
attribute :servers, :kind_of => Array, :default => []
attribute :balance, :kind_of => String
attribute :bind, :kind_of => String, :default => nil
attribute :mode, :kind_of => String, :default => nil,
  :equal_to => ['http', 'tcp', 'health', nil]

#I can't think of all parameters available in the future so we allow
#arbitrary params. Type can be array or hash because some attributes
#(like server) can set several times
attribute :params, :kind_of => [Array, Hash], :default => []
