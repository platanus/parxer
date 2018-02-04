module Parxer
  module Validator
    class FilePresence < Base
      def validate
        !context.file.to_s.blank?
      end
    end
  end
end
