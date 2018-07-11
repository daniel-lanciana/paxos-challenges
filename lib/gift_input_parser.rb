# frozen_string_literal: true

# Parse a gift input
module GiftInputParser
  DELIMITER = ', '

  def self.parse_line_amount(line)
    line.split(DELIMITER)[-1].to_i
  end
end
