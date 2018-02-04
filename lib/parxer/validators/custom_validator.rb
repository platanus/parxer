module Parxer
  module Validator
    class Custom < Base
      def id
        config[:id].to_sym
      end

      def validate
        if !config[:condition_proc].is_a?(Proc)
          raise Parxer::ValidatorError.new("'condition_proc' needs to be a Proc")
        end

        instance_eval(&config[:condition_proc])
      end
    end
  end
end
