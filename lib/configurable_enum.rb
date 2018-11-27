require 'configurable_enum/version'
require 'configurable_enum/enum_type'

module ConfigurableEnum
  def configurable_enum column_name,
                        mapping_class: [name, column_name.to_s.camelize, 'Mapping'].join
    mapping_model = mapping_class.to_s.constantize
    query_method = column_name.to_s.pluralize

    decorate_attribute_type(column_name, :enum) do |subtype|
      EnumType.new(column_name, self, subtype)
    end

    cache_key = "configurable_enum/#{self.class.name}/#{column_name}"
    # === Example for model `Book`'s column `category` ===
    # `Book.categories` returns the hash mapping from the stored data
    define_singleton_method query_method do
      Rails.cache.fetch(cache_key) do
        ActiveSupport::HashWithIndifferentAccess.new(
            mapping_model.all.map { |record| [ record.label, record.value ] }.to_h
        )
      end
    end

    # `Book.set_categories` will update or create the mapping records
    # that is specified by keys of the hash you provided
    define_singleton_method "set_#{query_method}" do |mapping|
      mapping.each_pair do |label, value|
        value, remarks = value if value.is_a?(Array)
        mapping_model.find_by(label: label)&.update(value: value, remarks: remarks) ||
            mapping_model.create(label: label, value: value, remarks: remarks)
      end
    end

    mapping_model.class_eval do
      default_scope { order(value: :asc) }
      after_commit { Rails.cache.delete(cache_key) }
    end
  end
end

# ActiveSupport.on_load(:active_record_base) do
  ActiveRecord::Base.extend ConfigurableEnum
# end
