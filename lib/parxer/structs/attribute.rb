class Parxer::Attribute
  attr_reader :id, :name
  attr_accessor :validators

  def initialize(id, name: nil)
    @id = id.to_sym
    @name = name
    @validators = []
  end
end
