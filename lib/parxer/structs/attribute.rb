class Parxer::Attribute
  attr_reader :id, :name

  def initialize(id, name: nil)
    @id = id.to_sym
    @name = name
  end
end
