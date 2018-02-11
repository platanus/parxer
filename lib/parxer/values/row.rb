module Parxer
  class Row
    extend Forwardable

    attr_reader :idx

    def_delegators :errors, :add_error, :attribute_error, :attribute_error?, :errors?

    def initialize(idx: nil)
      @idx = idx
    end

    def errors
      @errors ||= Parxer::RowErrors.new
    end
  end
end
