# frozen_string_literal: true

# rubocop:disable LineLength

require 'spec_helper'
require 'binary_wildcard_replacer'

describe '#binary_wildcard' do
  it 'should print no wildcards' do
    expect(BinaryWildcardReplacer.replace('10110010100101')).to eq('10110010100101')
  end

  it 'should print a single wildcard' do
    expect(BinaryWildcardReplacer.replace('X0')).to eq('00\n10')
  end

  it 'should print lowercase wildcards' do
    expect(BinaryWildcardReplacer.replace('x0')).to eq('00\n10')
  end

  it 'should print two wildcards' do
    expect(BinaryWildcardReplacer.replace('10X10X0')).to eq('1001000\n1001010\n1011000\n1011010')
  end

  it 'should print five wildcards' do
    expect(BinaryWildcardReplacer.replace('XXX10XX')).to eq('0001000\n0001001\n0001010\n0001011\n0011000\n0011001\n0011010\n0011011\n0101000\n0101001\n0101010\n0101011\n0111000\n0111001\n0111010\n0111011\n1001000\n1001001\n1001010\n1001011\n1011000\n1011001\n1011010\n1011011\n1101000\n1101001\n1101010\n1101011\n1111000\n1111001\n1111010\n1111011')
  end
end
# rubocop:enable LineLength
