# frozen_string_literal: true

require 'spec_helper'
require 'binary_wildcard_replacer'

describe '#binary_wildcard' do
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
    expect(STDOUT).to receive(:puts).with('0001000')
    expect(STDOUT).to receive(:puts).with('0001001')
    expect(STDOUT).to receive(:puts).with('0001010')
    expect(STDOUT).to receive(:puts).with('0001011')
    expect(STDOUT).to receive(:puts).with('0011000')
    expect(STDOUT).to receive(:puts).with('0011001')
    expect(STDOUT).to receive(:puts).with('0011010')
    expect(STDOUT).to receive(:puts).with('0011011')
    expect(STDOUT).to receive(:puts).with('0101000')
    expect(STDOUT).to receive(:puts).with('0101001')
    expect(STDOUT).to receive(:puts).with('0101010')
    expect(STDOUT).to receive(:puts).with('0101011')
    expect(STDOUT).to receive(:puts).with('0111000')
    expect(STDOUT).to receive(:puts).with('0111001')
    expect(STDOUT).to receive(:puts).with('0111010')
    expect(STDOUT).to receive(:puts).with('0111011')
    expect(STDOUT).to receive(:puts).with('1001000')
    expect(STDOUT).to receive(:puts).with('1001001')
    expect(STDOUT).to receive(:puts).with('1001010')
    expect(STDOUT).to receive(:puts).with('1001011')
    expect(STDOUT).to receive(:puts).with('1011000')
    expect(STDOUT).to receive(:puts).with('1011001')
    expect(STDOUT).to receive(:puts).with('1011010')
    expect(STDOUT).to receive(:puts).with('1011011')
    expect(STDOUT).to receive(:puts).with('1101000')
    expect(STDOUT).to receive(:puts).with('1101001')
    expect(STDOUT).to receive(:puts).with('1101010')
    expect(STDOUT).to receive(:puts).with('1101011')
    expect(STDOUT).to receive(:puts).with('1111000')
    expect(STDOUT).to receive(:puts).with('1111001')
    expect(STDOUT).to receive(:puts).with('1111010')
    expect(STDOUT).to receive(:puts).with('1111011')
    BinaryWildcardReplacer.replace 'XXX10XX'
  end
end
