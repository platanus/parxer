class Parxer::CustomValidator < Parxer::BaseValidator
  def initialize(context, validator_proc)
    @validator_proc = validator_proc
    super(context)
  end

  def validator
    if !@validator_proc.is_a?(Proc)
      raise Parxer::ValidatorError.new("'validator_proc' needs to be a Proc")
    end

    @validator_proc
  end
end
