module Parxer
  module ParserConfig
    extend ActiveSupport::Concern

    included do
      attr_reader :parser_config

      def parser_config
        @parser_config ||= inherited_hash(self, :parser_config)
      end
    end

    class_methods do
      def parser_config
        @parser_config ||= {}
      end

      def add_config_option(key, value)
        parser_config[key.to_sym] = value
      end
    end
  end
end
