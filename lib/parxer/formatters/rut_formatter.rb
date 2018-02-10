module Parxer
  module Formatter
    class Rut < Base
      def format_value(rut)
        rut = clean_rut(rut)
        return nil if rut.empty?
        return rut if clean_rut?
        format_rut(rut)
      end

      def clean_rut(rut)
        rut.scan(/(\d|k)/i).flatten.join("").upcase
      end

      def format_rut(rut)
        last_digit = rut[-1]
        digits = rut[0...-1].split("").reverse
        result = []

        digits.each_with_index do |number, idx|
          result << "." if !idx.zero? && (idx % 3).zero?
          result << number
        end

        result.reverse.join("") + "-" + last_digit
      end

      def clean_rut?
        !!config[:clean]
      end
    end
  end
end
