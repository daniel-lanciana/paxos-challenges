# frozen_string_literal: true

# Accepts a file_path and gift card balance, outputs the closest two gifts (without going over)
# from the loaded file of gift prices. If no matches found outputs 'Not possible'.
module GiftCardSelector
  ERROR_MSG = 'Not possible'
  INPUT_DELIMITER = ', '
  NEWLINE_CHARACTER = "\n"
  DEFAULT_GIFTS = 2
  MIN_LINE_LENGTH = 4

  def self.select(path, amount, max_gifts = DEFAULT_GIFTS)
    gifts = []

    # get the lowest item, don't accept anything with 2 or more that is greater than amount - lowest

    file = open_file(path)
    lowest = parse_line_amount(file.gets)

    (1..max_gifts).each do |index|
      previous_amount = gifts.last ? gifts.last[:amount] : amount
      previous_amounts = gifts.inject(0) { |sum, gift| sum + gift[:amount] }

      ideal_amount = amount.to_i - ((max_gifts > 1) && (index == 1) ? lowest : previous_amounts)
      ideal_amount = (previous_amount < ideal_amount) ? previous_amount - 1 : ideal_amount

      result = binary_search(file, ideal_amount)

      gifts << build_gift_obj_from_line(result) if result
    end

    gifts.count == max_gifts ? gifts.reverse.map { |gift| gift[:label] }.join(', ') : ERROR_MSG
  end

  def self.open_file(path)
    File.open "#{Dir.pwd}/#{path}"
  rescue Error
    puts "Couldn't open file '#{"#{Dir.pwd}/#{path}"}'...please check the path"
  end

  def self.binary_search(file, target, lower=0, upper=file.size, closest_match=nil)
    return closest_match if end_of_file_reached?(lower, upper)

    line = get_middle_line!(file, lower, upper)
    line_amount = parse_line_amount(line)

    if line_amount == target
      return line
    elsif line_amount < target
      closest_match = line
      # Set lower to the end of the line
      binary_search file, target, file.pos + line.length, upper, closest_match
    else
      # Set upper to the start of the line
      binary_search file, target, lower, file.pos, closest_match
    end
  end

  def self.end_of_file_reached?(lower, upper)
    # number of bits in file may be uneven, so allow buffer of the minimum gift
    # entry (e.g. "a, 1\n")
    upper - lower <= MIN_LINE_LENGTH
  end

  def self.build_gift_obj_from_line(line)
    {
        label: line.tr(',', '').strip,
        amount: parse_line_amount(line)
    }
  end

  def self.get_middle_line!(file, lower, upper)
    goto_middle_of_file!(file, lower, upper) and get_full_line(file)
  end

  def self.goto_middle_of_file!(file, lower, upper)
    file.seek (lower + upper) / 2
  end

  def self.get_full_line(file)
    original_pos = file.pos
    rewind_line(file, file.gets)
  ensure
    # Return original file position (for accurate binary searching)
    file.seek original_pos
  end

  def self.rewind_line(file, line)
    until file_at_starting_position?(file, line)
      line_rewind_one_char(file, line) { |rewound_line|
        return line if newline?(rewound_line)
        line = rewound_line
      }
    end

    line
  end

  def self.newline?(line)
    line == NEWLINE_CHARACTER
  end

  def self.line_rewind_one_char(file, line)
    # File position currently at the end of the line
    file.seek file.pos - (line.length + 1)
    yield file.gets
  end

  def self.file_at_starting_position?(file, line)
    file.pos == line.length
  end

  def self.parse_line_amount(line)
    line.split(INPUT_DELIMITER)[-1].to_i
  end
end
