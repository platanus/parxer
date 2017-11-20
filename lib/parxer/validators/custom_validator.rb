class Parxer::CustomValidator < Parxer::BaseValidator
  def initialize(id: nil, condition_proc: nil, config: {})
    if !condition_proc.is_a?(Proc)
      raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
    end

    @id = id.to_sym
    @condition = condition_proc
    @config = config
  end

  def condition
    @condition
  end

  def validate(ctx)
    !!ctx.instance_exec(&condition)
  end
end
