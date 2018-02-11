module Parxer
  module ParserCallback
    extend ActiveSupport::Concern

    included do
      def parser_callbacks
        @parser_callbacks ||= inherited_collection(self, :parser_callbacks, Parxer::Callbacks)
      end

      def after_parse_row
        parser_callbacks.by_type(:after_parse_row).each do |callback|
          callback.context = self
          callback.run
        end
      end
    end

    class_methods do
      def parser_callbacks
        @parser_callbacks ||= Parxer::Callbacks.new
      end
    end
  end
end
