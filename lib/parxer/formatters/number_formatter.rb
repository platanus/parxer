module Parxer
  module Formatter
    class Number < Base
      def format_value(v)
        v = integer? ? v.to_i : v.to_f
        v = v.round(round) if round?
        v
      end

      private

      def integer?
        !!config[:integer]
      end

      def round?
        !integer? && !!config[:round]
      end

      def round
        config[:round].to_s.to_i
      end
    end
  end
end
