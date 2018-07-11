# frozen_string_literal: true

require 'spec_helper'
require 'gift_card_selector'

describe '#gift_card_selector' do
  let(:input_path_1) { 'spec/fixtures/gift_prices_input_1.txt' }
  let(:input_path_2) { 'spec/fixtures/gift_prices_input_2.txt' }

  describe 'with 1 max guest' do
    it 'should find no matches' do
      expect(GiftCardSelector.select(input_path_1, 400, 1, 1)).to eq('Not possible')
    end

    it 'should find match with no remainder' do
      expect(GiftCardSelector.select(input_path_1, 2000, 1, 1)).to eq('Earmuffs 2000')
    end

    it 'should find match with remainder' do
      expect(GiftCardSelector.select(input_path_1, 2500, 1, 1)).to eq('Earmuffs 2000')
    end

    it 'should find match with remainder' do
      expect(GiftCardSelector.select(input_path_1, 1600, 1, 1)).to eq('Headphones 1400')
    end

    it 'should find first match' do
      expect(GiftCardSelector.select(input_path_1, 500, 1, 1)).to eq('Candy Bar 500')
    end

    it 'should find last match' do
      expect(GiftCardSelector.select(input_path_1, 6000, 1, 1)).to eq('Bluetooth Stereo 6000')
    end
  end

  describe 'with 2 max guests' do
    it 'should find no matches' do
      expect(GiftCardSelector.select(input_path_1, 1100)).to eq('Not possible')
    end

    it 'should find 2 matches with no remainder' do
      expect(GiftCardSelector.select(input_path_1, 2500)).to eq('Candy Bar 500, Earmuffs 2000')
    end

    it 'should find 2 matches with remainder' do
      expect(GiftCardSelector.select(input_path_1, 2300)).to eq('Paperback Book 700, Headphones 1400')
    end

    it 'should find last 2 matches' do
      expect(GiftCardSelector.select(input_path_1, 10_000)).to eq('Earmuffs 2000, Bluetooth Stereo 6000')
    end
  end

  describe 'when optimal solution is in the middle' do
    it 'should find 2 matches with no remainder' do
      expect(GiftCardSelector.select(input_path_2, 97)).to eq('Detergent 48, Headphones 49')
    end
  end
end
