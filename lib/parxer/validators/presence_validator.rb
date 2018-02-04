module Parxer
  module Validator
    class Presence < Base
      def validate
        !context.value.to_s.blank?
      end
    end
  end
end
