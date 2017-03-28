property :name, String
property :section, String, equal_to: %w(frontend listen backend), name_attribute: true
property :section_name, String, default: 'default'
property :criterion, String
property :flags, String
property :operator, String
property :value, String

action :create do
end
