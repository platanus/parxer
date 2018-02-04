module Parxer
  module Formatter
    class Custom < Base
      def format_value(_v)
        if !config[:formatter_proc].is_a?(Proc)
          raise Parxer::FormatterError.new("'formatter_proc' needs to be a Proc")
        end

        instance_eval(&config[:formatter_proc])
      end
    end
  end
end
