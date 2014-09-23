require 'chefspec'
require 'chefspec/librarian'

at_exit { ChefSpec::Coverage.report! }
