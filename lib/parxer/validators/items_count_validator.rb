class Parxer::ItemsCountValidator < Parxer::BaseValidator
  def validate
    context.items_count <= config[:max].to_i
  end
end
