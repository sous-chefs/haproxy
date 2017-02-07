property :name, String, default: 'default', name_attribute: true
property :section, String, default: 'frontend', equal_to: %w(frontend listen backend)
property :section_name, String, default: 'default'
property :criterion, String
property :flags, String
property :operator, String
property :value, String
