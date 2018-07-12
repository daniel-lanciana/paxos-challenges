# frozen_string_literal: true

require 'spec_helper'
require 'gift_card_spender'

describe '#gift_card_spender' do
  let(:input_path_1) { 'spec/fixtures/gift_prices_input_1.txt' }
  let(:input_path_2) { 'spec/fixtures/gift_prices_input_2.txt' }

  describe 'with 1 max gift' do
    before(:each) do
      @spender = GiftCardSpender.new(file_path: input_path_1,
                                     min_outputs: 1,
                                     max_outputs: 1)
    end

    it 'should find no matches' do
      expect(@spender.spend(400)).to eq('Not possible')
    end

    it 'should find match with no remainder' do
      expect(@spender.spend(2000)).to eq('Earmuffs 2000')
    end

    it 'should find match with remainder' do
      expect(@spender.spend(2500)).to eq('Earmuffs 2000')
    end

    it 'should find match with remainder' do
      expect(@spender.spend(1600)).to eq('Headphones 1400')
    end

    it 'should find first match' do
      expect(@spender.spend(500)).to eq('Candy Bar 500')
    end

    it 'should find last match' do
      expect(@spender.spend(6000)).to eq('Bluetooth Stereo 6000')
    end
  end

  describe 'with 2 max gifts' do
    before(:each) do
      @spender = GiftCardSpender.new(file_path: input_path_1)
    end

    it 'should find no matches' do
      expect(@spender.spend(1100)).to eq('Not possible')
    end

    it 'should find 2 matches with no remainder' do
      expect(@spender.spend(2500))
        .to eq('Candy Bar 500, Earmuffs 2000')
    end

    it 'should find 2 matches with remainder' do
      expect(@spender.spend(2300))
        .to eq('Paperback Book 700, Headphones 1400')
    end

    it 'should find last 2 matches' do
      expect(@spender.spend(10_000))
        .to eq('Earmuffs 2000, Bluetooth Stereo 6000')
    end
  end

  describe 'when optimal solution is in the middle' do
    it 'should find 2 matches with no remainder' do
      spender = GiftCardSpender.new(file_path: input_path_2)
      expect(spender.spend(97)).to eq('Detergent 48, Headphones 49')
    end
  end

  describe 'with 3 max gifts' do
    it 'should find no matches' do
      spender = GiftCardSpender.new(file_path: input_path_1,
                                    min_outputs: 2,
                                    max_outputs: 3)
      expect(spender.spend(1100)).to eq('Not possible')
    end

    it 'should find 3 matches with no remainder' do
      spender = GiftCardSpender.new(file_path: input_path_1,
                                    min_outputs: 3,
                                    max_outputs: 3)
      expect(spender.spend(9000))
        .to eq('Detergent 1000, Earmuffs 2000, Bluetooth Stereo 6000')
    end
  end
end
