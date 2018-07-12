# frozen_string_literal: true

require './lib/file_binary_search'
require './lib/gift_input_parser'

# Accepts a file_path and gift card balance, outputs the closest two gifts
# (without going over) from the loaded file of gift prices. If no matches
# found outputs 'Not possible'.
class GiftCardSpender
  ERROR_MSG = 'Not possible'
  DELIMITER = ', '
  DEFAULT_MIN = 2
  DEFAULT_MAX = 2

  def initialize(args)
    @file = open_file(args[:file_path])
    @parser = GiftInputParser
    @min_outputs = args[:min_outputs] || DEFAULT_MIN
    @max_outputs = args[:max_outputs] || DEFAULT_MAX
    @search = FileBinarySearch.new(file: @file, parser: @parser)
  end

  def spend(amount)
    results = find_optimal_spend(amount, Float::INFINITY, [])
    build_output_from_array results
  end

  private

  def open_file(path)
    File.open "#{Dir.pwd}/#{path}"
  rescue Error
    puts "Couldn't open file '#{"#{Dir.pwd}/#{path}"}'...please check the path"
  end

  def find_optimal_spend(amount, min_amount, best_result)
    # Stop when our starting amount -- even if it occupied every result --
    # still totals less than our best (e.g. best is 10, starting amount less
    # than 5 has at best 4 + 4 = 8)
    return best_result unless
        min_amount > total_spent(best_result) / @min_outputs

    results = get_gifts([], amount, min_amount)

    # Replace the best result (if necessary), adjust min_amount to move
    # to the next lowest and recursively fetch results
    find_optimal_spend(amount,
                       get_largest_gift_amount(results) - 1,
                       return_best_gift_array(best_result, results))
  end

  def get_gifts(exclusions, amount, max_amount)
    min_amount = @parser.parse_line_amount(@file.gets)
    search_gifts(exclusions, amount, min_amount, max_amount)
  end

  def search_gifts(exclusions, amount, min_amount, max_amount)
    results = []

    (1..@max_outputs).each do |index|
      target = calculate_target_amount(results, amount, index,
                                       min_amount, max_amount)
      line = @search.find(exclusions, target)
      results << build_result(line) && exclusions << line if line
    end && results
  end

  def calculate_target_amount(results, balance, iteration, min_amount,
                              max_amount)
    # If we require more than 1 result and this is the first iteration, deduct
    # the lowest item from the balance (as we can't select an amount greater
    # with no corresponding match) (e.g. bal 10, lowest 3, target 7 or below)
    deduction = if @min_outputs > iteration && iteration == 1
                  min_amount
                else
                  total_spent(results)
                end

    balance_left_to_spend = balance.to_i - deduction
    # Adjust if a max amount is capped (i.e. for finding the optimal solution)
    balance_left_to_spend > max_amount ? max_amount : balance_left_to_spend
  end

  def total_spent(results)
    results.inject(0) { |sum, result| sum + result[:amount] }
  end

  def valid_number_of_gifts?(results)
    results.count >= @min_outputs && results.count <= @max_outputs
  end

  def return_best_gift_array(results1, results2)
    total_spent(results1) > total_spent(results2) ? results1 : results2
  end

  def get_largest_gift_amount(results)
    results.empty? ? 0 : results.first[:amount] - 1
  end

  def build_result(line)
    {
      label: line.tr(',', '').strip,
      amount: @parser.parse_line_amount(line)
    }
  end

  def build_output_from_array(results)
    if valid_number_of_gifts?(results)
      results.reverse.map { |result| result[:label] }.join(DELIMITER)
    else
      ERROR_MSG
    end
  end
end
