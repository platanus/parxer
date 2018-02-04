# rubocop:disable Metrics/LineLength
module Parxer
  module Validator
    class Email < Base
      EMAIL_REGEXP = %r{\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z}

      def validate
        v = context.value.to_s
        return true if v.blank?
        !!(v =~ EMAIL_REGEXP)
      end
    end
  end
end
