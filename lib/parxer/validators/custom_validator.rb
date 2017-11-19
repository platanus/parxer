class Parxer::CustomValidator < Parxer::BaseValidator
  def initialize(id, condition_proc)
    if !condition_proc.is_a?(Proc)
      raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
    end

    @id = id.to_sym
    @condition = condition_proc
  end

  def condition
    @condition
  end

  def validate(ctx)
    !!ctx.instance_exec(&condition)
  end
end
