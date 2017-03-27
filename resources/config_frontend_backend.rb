property :name, String, default: 'default', name_attribute: true
property :frontend_name, String
property :if_unless, String, default: 'if', equal_to: %w(if unless)
property :condition, String
property :default, [TrueClass, FalseClass], default: false
