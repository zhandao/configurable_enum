module ConfigurableEnum
  class EnumType < ActiveRecord::Type::Value # :nodoc:
    delegate :type, to: :subtype
    attr_reader :col_name, :mapping, :subtype

    def initialize(col_name, kls, subtype)
      @col_name = col_name
      @kls = kls
      @subtype = subtype
    end

    def mapping
      @kls.send(col_name.to_s.pluralize)
    end

    def cast(value)
      return if value.blank?

      if mapping.has_key?(value)
        value.to_s
      elsif mapping.has_value?(value)
        mapping.key(value)
      else
        assert_valid_value(value)
      end
    end

    def deserialize(value)
      return if value.nil?
      mapping.key(subtype.deserialize(value))
    end

    def serialize(value)
      mapping.fetch(value, value)
    end

    def assert_valid_value(value)
      unless value.blank? || mapping.has_key?(value) || mapping.has_value?(value)
        raise ArgumentError, "'#{value}' is not a valid #{col_name}"
      end
    end
  end
end
