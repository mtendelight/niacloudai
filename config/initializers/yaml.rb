# config/initializers/yaml.rb

# Allow BigDecimal and other necessary classes for YAML serialization
Rails.application.config.active_record.yaml_column_permitted_classes = [BigDecimal, Symbol, Date, Time, ActiveSupport::TimeWithZone]
