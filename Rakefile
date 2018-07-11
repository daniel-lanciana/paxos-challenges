# frozen_string_literal: true

require 'rspec/core/rake_task'
require './lib/binary_wildcard_replacer'
require './lib/gift_card_selector'
require 'benchmark'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :replace_wildcards, [:input] do |_task, args|
  running_time = Benchmark.realtime do
    BinaryWildcardReplacer.replace args[:input]
  end

  puts "\nRunning time: #{running_time.round(2)} seconds"
end

task :select_gifts, [:file_path,
                     :balance,
                     :min_outputs,
                     :max_outputs] do |_task, args|

  running_time = Benchmark.realtime do
    if args[:max_gifts]
      puts GiftCardSelector.select args[:file_path],
                                   args[:balance],
                                   args[:min_outputs].to_i,
                                   args[:max_outputs].to_i
    else
      puts GiftCardSelector.select args[:file_path],
                                   args[:balance]
    end
  end

  puts "\nRunning time: #{running_time.round(2)} seconds"
end
