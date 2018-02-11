module Parxer
  module Validator
    class RowsCount < Base
      def validate
        context.rows_count <= config[:max].to_i
      end
    end
  end
end
