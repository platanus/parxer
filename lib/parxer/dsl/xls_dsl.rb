module Parxer::XlsDsl
  def column(id, name: nil)
    raise Parxer::XlsDslError.new("nest column is not allowed") if @current_attr
    @current_attr = attributes.add_attribute(id, name: name)
    yield if block_given?
  ensure
    @current_attr = nil
  end
end
