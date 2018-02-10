module Parxer
  module XlsDsl
    extend ActiveSupport::Concern
    include Parxer::Dsl

    included do |base|
      define_alias_method(base, :define_file_validator, :validate_xls)
      define_alias_method(base, :define_attribute, :column)
      define_alias_method(base, :define_after_parse_item_callback, :after_parse_row)
      define_alias_method(base, :define_attribute_validator, :validate)
      define_alias_method(base, :define_formatter, :format_with)
    end
  end
end
