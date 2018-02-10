module Parxer
  class Callback
    include Parxer::Context

    attr_reader :type, :action, :config

    def initialize(type: nil, action: nil, config: {})
      @type = type.to_sym
      @context = config.delete(:context)
      @config = config
      @action = action
    end

    def run
      if action.is_a?(Proc)
        instance_eval(&action)
      else
        context.send(action)
      end
    end
  end
end
