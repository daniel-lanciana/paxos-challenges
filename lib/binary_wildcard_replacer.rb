# frozen_string_literal: true

# Takes a string input and replaces each 'x' or 'X' with both '0' and '1'
# (over multiple lines)
module BinaryWildcardReplacer
  WILDCARD_CHARACTER = 'X'

  def self.replace(input)
    recursively input.chars, wildcard_positions_to_array(input), 0
  end

  def self.recursively(input_array, wildcards, counter)
    puts replace_wildcards(input_array,
                           wildcards,
                           number_as_binary_array(counter, wildcards.length))
    recursively(input_array, wildcards, counter + 1) if
        replaced_all_variables?(counter, wildcards)
  end

  def self.replaced_all_variables?(counter, wildcards)
    # 2 ^ number of wildcards (e.g. 2 wildcards = 4 outputs [00, 01, 10, 11])
    counter < (2**wildcards.length - 1)
  end

  def self.number_as_binary_array(number, fixed_length)
    format("%0#{fixed_length}b", number).chars
  end

  def self.wildcard_positions_to_array(input)
    (0...input.length).find_all { |i| input.upcase[i, 1] == WILDCARD_CHARACTER }
  end

  def self.replace_wildcards(input_array, positions, binary)
    positions.each_with_index { |pos, index| input_array[pos] = binary[index] }
    input_array.join
  end
end
