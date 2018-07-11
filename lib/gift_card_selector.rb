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
    lowest = parse_gift_amount(file.gets)

    (1..max_gifts).each do |index|
      previous_amount = gifts.last ? gifts.last[:amount] : amount
      previous_amounts = gifts.inject(0) { |sum, gift| sum + gift[:amount] }

      ideal_amount = amount.to_i - ((max_gifts > 1) && (index == 1) ? lowest : previous_amounts)
      ideal_amount = (previous_amount < ideal_amount) ? previous_amount - 1 : ideal_amount

      result = binary_search(file, ideal_amount)

      gifts << result if result
    end

    gifts.count == max_gifts ? gifts.reverse.map { |gift| gift[:label] }.join(', ') : ERROR_MSG
  end

  def self.open_file(path)
    File.open "#{Dir.pwd}/#{path}"
  rescue Error
    puts "Couldn't open file '#{"#{Dir.pwd}/#{path}"}'...please check the path"
  end

  def self.binary_search(file, amount)
    lower = 0
    upper = file.size
    closest_line = nil

    loop do
      # Go to middle of file
      file.seek (upper + lower) / 2

      line = get_full_line(file)
      line_amount = parse_gift_amount(line)

      p "pos #{file.pos}, line #{line}"

      if line_amount < amount
        # Set lower to the end of the line
        lower = file.pos + line.length
        closest_line = line
      elsif line_amount > amount
        # Set upper to the start of the line
        upper = file.pos
      elsif line_amount == amount
        closest_line = line
      end

      # trying to divide the first line
      # return nil if lower == before_lower and upper == before_upper
      return nil if upper < line.length

      # optimize exit binary search way before dividing down to the
      # last bits!

      # number of bits in file may be uneven, so allow buffer
      if ((upper - lower) <= MIN_LINE_LENGTH) || (line_amount == amount)
        return {
          label: closest_line.tr(',', '').strip,
          amount: parse_gift_amount(closest_line)
        }
      end
      # exit if start or end of file reached..
    end
  end

  def self.get_full_line(file)
    original_pos = file.pos
    line = file.gets
    exit_loop = false

    # Move back one character at a time until we hit the previous newline
    # Then the next file.gets will be the line we originally landed on.
    # No better way to rewind with seek as far as I know..
    until (file.pos == line.length) || exit_loop
      file.seek file.pos - (line.length + 1)
      temp_line = file.gets

      if temp_line == NEWLINE_CHARACTER
        exit_loop = true
      else
        line = temp_line
      end
    end

    file.seek original_pos
    line
  end

  def self.parse_gift_amount(line)
    line.split(INPUT_DELIMITER)[-1].to_i
  end
end
