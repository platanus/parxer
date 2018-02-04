module Parxer
  module Validator
    class Number < Base
      def validate
        v = context.value.to_s
        return true if v.blank?
        return false unless validate_number(v)
        return false unless validate_negative(v)
        validate_range(v)
      end

      private

      def allow_negative?
        !!config[:allow_negative]
      end

      def only_integer?
        !!config[:only_integer]
      end

      def validate_number(v)
        only_integer? ? valid_integer?(v) : valid_float?(v)
      end

      def valid_integer?(v)
        !!(v.to_s =~ /\A[-+]?[0-9]+\z/)
      end

      def valid_float?(v)
        !!Float(v)
      rescue ArgumentError
        false
      end

      def validate_negative(v)
        !(!allow_negative? && v.to_i.negative?)
      end

      def validate_range(v)
        v = only_integer? ? v.to_i : v.to_f
        return false unless validate_limit(:gt, ">", v)
        return false unless validate_limit(:gteq, ">=", v)
        return false unless validate_limit(:lt, "<", v)
        return false unless validate_limit(:lteq, "<=", v)
        true
      end

      def validate_limit(limit_name, method, v)
        r = valid_limit(limit_name)
        return true if r.blank?
        v.public_send(method, r)
      end

      def valid_limit(name)
        limit = config[name]
        return if limit.blank?
        return (only_integer? ? limit.to_i : limit.to_f) if validate_number(limit)
        raise Parxer::ValidatorError.new("'#{name}' has not a valid value for given number type")
      end
    end
  end
end
