# frozen_string_literal: true

require 'spec_helper'
require 'binary_wildcard_replacer'

describe '#binary_wildcard' do
  let(:fixture) { IO.readlines('spec/fixtures/wildcard_test_output.txt') }

  it 'should print no wildcards' do
    expect(STDOUT).to receive(:puts).with('10110010100101')
    BinaryWildcardReplacer.replace '10110010100101'
  end

  it 'should print a single wildcard' do
    expect(STDOUT).to receive(:puts).with('00')
    expect(STDOUT).to receive(:puts).with('10')
    BinaryWildcardReplacer.replace 'X0'
  end

  it 'should print lowercase wildcards' do
    expect(STDOUT).to receive(:puts).with('00')
    expect(STDOUT).to receive(:puts).with('10')
    BinaryWildcardReplacer.replace 'x0'
  end

  it 'should print two wildcards' do
    expect(STDOUT).to receive(:puts).with('1001000')
    expect(STDOUT).to receive(:puts).with('1001010')
    expect(STDOUT).to receive(:puts).with('1011000')
    expect(STDOUT).to receive(:puts).with('1011010')
    BinaryWildcardReplacer.replace '10X10X0'
  end

  it 'should print five wildcards' do
    fixture.each { |line| expect(STDOUT).to receive(:puts).with(line.strip) }
    BinaryWildcardReplacer.replace 'XXX10XX'
  end
end
