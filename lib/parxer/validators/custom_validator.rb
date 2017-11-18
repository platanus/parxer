class Parxer::CustomValidator < Parxer::BaseValidator
  def initialize(condition_proc)
    if !condition_proc.is_a?(Proc)
      raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
    end

    @condition = condition_proc
  end

  def condition
    @condition
  end

  def validate(ctx)
    !!ctx.instance_exec(&@condition)
  end
end
