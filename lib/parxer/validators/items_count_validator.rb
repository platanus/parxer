module Parxer
  module Validator
    class ItemsCount < Base
      def validate
        context.items_count <= config[:max].to_i
      end
    end
  end
end
