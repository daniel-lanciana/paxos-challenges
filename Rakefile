# frozen_string_literal: true

require 'rspec/core/rake_task'
require './lib/binary_wildcard_replacer'
require 'benchmark'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :replace_wildcards, [:input] do |_task, args|
  running_time = Benchmark.realtime do
    BinaryWildcardReplacer.replace args[:input]
  end

  puts "\nRunning time: #{running_time.round(2)} milliseconds"
end