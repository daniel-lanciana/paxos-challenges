# frozen_string_literal: true

require 'rspec/core/rake_task'
require './lib/binary_wildcard_replacer'
require './lib/gift_card_spender'
require 'benchmark'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :replace_wildcards, [:input] do |_task, args|
  running_time = Benchmark.realtime do
    BinaryWildcardReplacer.replace args[:input]
  end

  puts "\nRunning time: #{running_time.round(2)} seconds"
end

task :spend_gift_card, [:file_path,
                        :balance,
                        :min_outputs,
                        :max_outputs] do |_task, args|

  running_time = Benchmark.realtime do
    min_outputs = args[:min_outputs] ? args[:min_outputs].to_i : nil
    max_outputs = args[:max_outputs] ? args[:max_outputs].to_i : nil

    gift_selector = GiftCardSpender.new(file_path: args[:file_path],
                                        min_outputs: min_outputs,
                                        max_outputs: max_outputs)

    puts gift_selector.spend args[:balance].to_i
  end

  puts "\nRunning time: #{running_time.round(2)} seconds"
end
