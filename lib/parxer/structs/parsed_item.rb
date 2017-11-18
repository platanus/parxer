class Parxer::ParsedItem
  extend Forwardable

  attr_reader :idx

  def_delegator :errors, :add_error

  def initialize(idx: nil)
    @idx = idx
  end

  def add_error(attribute_name, error)
    errors.add_error(attribute_name, error)
  end

  def errors
    @errors ||= Parxer::ItemErrors.new
  end
end