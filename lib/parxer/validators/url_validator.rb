module Parxer
  module Validator
    class Url < Base
      def validate
        v = context.value.to_s
        return true if v.blank?
        !!(v =~ URI.regexp)
      end
    end
  end
end
