# frozen_string_literal: true

require 'spec_helper'
require 'gift_card_selector'

describe '#gift_card_selector' do
  let(:input_path_1) { 'spec/fixtures/gift_prices_input_1.txt' }

  it 'should find no matches' do
    expect(STDOUT).to receive(:puts).with('Not possible')
    GiftCardSelector.select input_path_1, 1100
  end

  it 'should find 2 matches with no remainder' do
    expect(STDOUT).to receive(:puts).with('Candy Bar 500, Earmuffs 2000')
    GiftCardSelector.select input_path_1, 2500
  end

  it 'should find 2 matches with remainder' do
    expect(STDOUT).to receive(:puts).with('Paperback Book 700, Headphones 1400')
    GiftCardSelector.select input_path_1, 2300
  end

  it 'should find top 2 matches' do
    expect(STDOUT).to receive(:puts).with('Earmuffs 2000, Bluetooth Stereo 6000')
    GiftCardSelector.select input_path_1, 10000
  end
end
