class Parxer::CustomValidator < Parxer::BaseValidator
  def initialize(context, condition_proc)
    if !condition_proc.is_a?(Proc)
      raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
    end

    @condition = condition_proc
    super context
  end

  def condition
    @condition
  end

  def validate
    !!context.instance_exec(&@condition)
  end
end
