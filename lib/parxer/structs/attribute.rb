class Parxer::Attribute
  extend Forwardable

  attr_reader :id, :name, :validators

  def_delegators :validators, :add_validator

  def initialize(id, name: nil)
    @id = id.to_sym
    @name = name
    @validators = Parxer::Validators.new
  end
end
