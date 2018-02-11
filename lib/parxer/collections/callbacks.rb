module Parxer
  class Callbacks < Array
    CALLBACK_TYPES = %i{after_parse_row}

    def add_callback(type: nil, action: nil, config: {})
      if !CALLBACK_TYPES.include?(type.to_sym)
        raise Parxer::CallbacksError.new("invalid '#{type}' callback type")
      end

      if !action.is_a?(Proc) && !action.is_a?(Symbol)
        raise Parxer::CallbacksError.new("action param must by a Proc or symbol method name")
      end

      self << Parxer::Callback.new(type: type, action: action, config: config || {})
      last
    end

    def by_type(type)
      select { |callback| callback.type == type.to_sym }
    end
  end
end
