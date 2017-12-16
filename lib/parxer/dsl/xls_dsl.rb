module Parxer::XlsDsl
  include Parxer::Dsl

  def ctx_dependencies_map
    {
      validate_xls: [],
      column: [],
      validate: [:column]
    }
  end

  def column(id, name: nil, &block)
    in_context do
      @current_att = attributes.add_attribute(id, name: name)
      block&.call
    end
  ensure
    @current_att = nil
  end

  def validate(validator_name, config = {}, &block)
    in_context do
      @current_att.add_validator(validator_name, config, &block)
    end
  end

  def validate_xls(validator_name, config = {}, &block)
    in_context do
      add_validator(validator_name, config, &block)
    end
  end
end
