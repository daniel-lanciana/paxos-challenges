# frozen_string_literal: true

require 'spec_helper'
require 'gift_card_selector'

describe '#gift_card_selector' do
  let(:input_path_1) { 'spec/fixtures/gift_prices_input_1.txt' }

  describe 'with 1 max guest' do
    it 'should find no matches' do
      expect(STDOUT).to receive(:puts).with('Not possible')
      GiftCardSelector.select input_path_1, 400, 1
    end

    it 'should find match with no remainder' do
      expect(STDOUT).to receive(:puts).with('Earmuffs 2000')
      GiftCardSelector.select input_path_1, 2000, 1
    end

    it 'should find match with remainder' do
      expect(STDOUT).to receive(:puts).with('Earmuffs 2000')
      GiftCardSelector.select input_path_1, 2500, 1
    end

    it 'should find match with remainder' do
      expect(STDOUT).to receive(:puts).with('Headphones 1400')
      GiftCardSelector.select input_path_1, 1600, 1
    end

    it 'should find first match' do
      expect(STDOUT).to receive(:puts).with('Candy Bar 500')
      GiftCardSelector.select input_path_1, 500, 1
    end

    it 'should find last match' do
      expect(STDOUT).to receive(:puts).with('Bluetooth Stereo 6000')
      GiftCardSelector.select input_path_1, 6000, 1
    end
  end

  describe 'with 2 max guests' do
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

    it 'should find last 2 matches' do
      expect(STDOUT).to receive(:puts).with('Earmuffs 2000, Bluetooth Stereo 6000')
      GiftCardSelector.select input_path_1, 10_000
    end
  end
end
