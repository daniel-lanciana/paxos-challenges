# frozen_string_literal: true

require './lib/gift_input_parser'

# Returns line of sorted file without loading everything into memory
class FileBinarySearch
  NEWLINE_CHARACTER = "\n"
  MIN_LINE_LENGTH = 4
  DELIMITER = ', '

  def initialize(args)
    @file = args[:file]
    @parser = args[:parser]
  end

  def find(exclusions, target, lower = 0,
           upper = @file.size, closest_match = nil)

    return closest_match if end_of_file_reached?(lower, upper)

    @line = get_middle_line!(@file, lower, upper)
    @line_amount = @parser.parse_line_amount(@line)

    return @line if @line_amount == target

    halve_and_find_again target, exclusions, lower, upper, closest_match
  end

  private

  def halve_and_find_again(target, exclusions, lower, upper, closest_match)
    if @line_amount < target
      closest_match = @line unless exclusions.include?(@line)
      # Set lower to the end of the line
      find exclusions, target, @file.pos + @line.length, upper,
           closest_match
    else
      # Set upper to the start of the line
      find exclusions, target, lower, @file.pos, closest_match
    end
  end

  def end_of_file_reached?(lower, upper)
    # number of bits in file may be uneven, so allow buffer of the minimum gift
    # entry (e.g. "a, 1\n")
    upper - lower <= MIN_LINE_LENGTH
  end

  def get_middle_line!(file, lower, upper)
    goto_middle_of_file!(file, lower, upper) && get_full_line(file)
  end

  def goto_middle_of_file!(file, lower, upper)
    file.seek((lower + upper) / 2)
  end

  def get_full_line(file)
    original_pos = file.pos
    rewind_line(file, file.gets)
  ensure
    # Return original file position (for accurate binary searching)
    file.seek original_pos
  end

  # If input lines are not equal length, we might land in the middle of a line
  def rewind_line(file, line)
    until file_at_starting_position?(file, line)
      line_rewind_one_char(file, line) do |rewound_line|
        return line if newline?(rewound_line)
        line = rewound_line
      end
    end

    line
  end

  def file_at_starting_position?(file, line)
    file.pos == line.length
  end

  def line_rewind_one_char(file, line)
    # File position currently at the end of the line
    file.seek file.pos - (line.length + 1)
    yield file.gets
  end

  def newline?(line)
    line == NEWLINE_CHARACTER
  end
end
