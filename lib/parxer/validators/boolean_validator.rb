module Parxer
  module Validator
    class Boolean < Base
      OPTIONS = ["true", "t", "1", "false", "f", "0"]

      def validate
        v = context.value.to_s
        return true if v.blank?
        OPTIONS.include?(v)
      end
    end
  end
end
