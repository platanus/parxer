module Parxer
  module Context
    extend ActiveSupport::Concern

    included do
      attr_writer :context

      def context
        raise Parxer::ContextError.new("'context' method not implemented") unless @context
        @context
      end

      def method_missing(method_name, *arguments, &block)
        if context.respond_to?(method_name)
          return context.send(method_name, *arguments, &block)
        end

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        context.respond_to?(method_name) || super
      end
    end
  end
end
