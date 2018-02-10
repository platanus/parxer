module Parxer
  class Attribute
    extend Forwardable

    attr_reader :id, :name, :validators, :formatter

    def_delegators :validators, :add_validator

    def initialize(id, name: nil)
      @id = id.to_sym
      @name = name
      @validators = Parxer::Validators.new
    end

    def add_formatter(formatter_name, config = {}, &block)
      @formatter = Parxer::FormatterBuilder.build(formatter_name, config, &block)
    end
  end
end
