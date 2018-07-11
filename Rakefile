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

task :select_gifts, [:file_path, :balance, :max_gifts] do |_task, args|
  running_time = Benchmark.realtime do
    if args[:max_gifts]
      GiftCardSelector.select args[:file_path], args[:balance], args[:max_gifts].to_i
    else
      GiftCardSelector.select args[:file_path], args[:balance]
    end
  end

  puts "\nRunning time: #{running_time.round(2)} seconds"
end
