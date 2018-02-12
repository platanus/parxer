module Parxer
  module Formatter
    class Boolean < Base
      TRUE_OPTIONS = ["true", "t", "1", "1.0"]
      FALSE_OPTIONS = ["false", "f", "0", "0.0"]

      def format_value(v)
        return true if TRUE_OPTIONS.include?(v)
        return false if FALSE_OPTIONS.include?(v)
        nil
      end
    end
  end
end
