# frozen_string_literal: true

require './lib/file_binary_search'
require './lib/gift_input_parser'

# Accepts a file_path and gift card balance, outputs the closest two gifts (without going over)
# from the loaded file of gift prices. If no matches found outputs 'Not possible'.
module GiftCardSelector
  ERROR_MSG = 'Not possible'
  DELIMITER = ', '
  DEFAULT_MIN = 2
  DEFAULT_MAX = 2

  def self.select(path, amount, min_outputs = DEFAULT_MIN, max_outputs = DEFAULT_MAX)
    results = find_optimal_spend(open_file(path), amount, min_outputs, max_outputs, Float::INFINITY, [])
    build_output_from_array results, min_outputs, max_outputs
  end

  def self.open_file(path)
    File.open "#{Dir.pwd}/#{path}"
  rescue Error
    puts "Couldn't open file '#{"#{Dir.pwd}/#{path}"}'...please check the path"
  end

  def self.find_optimal_spend(file, amount, min_outputs, max_outputs, min_amount, optimal_results)
    # Stop when target first amount is less than half our current best
    return optimal_results unless min_amount > total_spent(optimal_results) / 2

    results = fetch_results(file, [], amount, min_outputs, max_outputs, min_amount)

    find_optimal_spend(file, amount, min_outputs, max_outputs,
                       get_largest_item_amount(results) - 1,
                       return_highest_spend(optimal_results, results))
  end

  def self.fetch_results(file, exclusions, amount, min_outputs, max_outputs, max_amount)
    results = []
    min_amount = GiftInputParser.parse_line_amount(file.gets)

    (1..max_outputs).each do |index|
      target = amount_to_search(results, amount, min_outputs, index, min_amount, max_amount)
      result = FileBinarySearch.binary_search(file, GiftInputParser, exclusions, target)
      results << build_gift_obj_from_line(result) && exclusions << result if result
    end

    results
  end

  def self.amount_to_search(results, balance, min_outputs, iteration, min_amount, max_amount)
    # If we require more than 1 result and this is the first iteration, deduct
    # the lowest item from the balance (as we can't select an amount greater with no
    # corresponding match)
    balance_left_to_spend = balance.to_i - (min_outputs > iteration && iteration == 1 ?
        min_amount : total_spent(results))
    balance_left_to_spend > max_amount ? max_amount : balance_left_to_spend
  end

  def self.total_spent(results)
    results.inject(0) { |sum, result| sum + result[:amount] }
  end

  def self.valid_number_of_selections?(array, min, max)
    array.count >= min && array.count <= max
  end

  def self.return_highest_spend(results1, results2)
    total_spent(results1) > total_spent(results2) ? results1 : results2
  end

  def self.get_largest_item_amount(results)
    results.empty? ? 0 : results.first[:amount] - 1
  end

  def self.build_gift_obj_from_line(line)
    {
      label: line.tr(',', '').strip,
      amount: GiftInputParser.parse_line_amount(line)
    }
  end

  def self.build_output_from_array(results, min_outputs, max_outputs)
    valid_number_of_selections?(results, min_outputs, max_outputs) ?
        results.reverse.map { |result| result[:label] }.join(DELIMITER) : ERROR_MSG
  end
end
