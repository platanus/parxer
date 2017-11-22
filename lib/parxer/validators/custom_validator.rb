class Parxer::CustomValidator < Parxer::BaseValidator
  def id
    config[:id].to_sym
  end

  def condition
    if !config[:condition_proc].is_a?(Proc)
      raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
    end

    config[:condition_proc].call
  end
end
