module Parxer
  module Validator
    class Inclusion < Base
      def validate
        v = context.value.to_s
        return true if v.blank?
        options.include?(v)
      end

      private

      def options
        @options ||= begin
          opts = config[:in]
          raise Parxer::ValidatorError.new("'in' config option is required") if opts.blank?

          if !opts.is_a?(Array)
            raise Parxer::ValidatorError.new("'in' config option needs to be Array")
          end

          opts.map(&:to_s)
        end
      end
    end
  end
end
