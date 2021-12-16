# frozen_string_literal: true

require_relative '../binary_reader'

RSpec.describe BinaryReader do
  let(:input) do
    [
      '00100',
      '11110',
      '10110',
      '10111',
      '10101',
      '01111',
      '00111',
      '11100',
      '10000',
      '11001',
      '00010',
      '01010'
    ]
  end

  describe '#gamma_rate' do
    subject do
      reader = BinaryReader.new
      reader.gamma_rate input: input
    end

    it 'returns the expected gamma rate' do
      expect(subject).to eq 22
    end
  end

  describe '#epsilon_rate' do
    subject do
      reader = BinaryReader.new
      reader.epsilon_rate input: input
    end

    it 'returns the expected epsilon rate' do
      expect(subject).to eq 9
    end
  end

  describe '#power_consumption' do
    subject do
      reader = BinaryReader.new
      reader.power_consumption input: input
    end

    it 'returns the expected power consumption' do
      expect(subject).to eq 198
    end
  end

  describe '#oxygen_generator_rating' do
    subject do
      reader = BinaryReader.new
      reader.oxygen_generator_rating input: input
    end

    it 'returns the expected oxygen generator rate' do
      expect(subject).to eq 23
    end
  end

  describe '#co2_scrubber_rating' do
    subject do
      reader = BinaryReader.new
      reader.co2_scrubber_rating input: input
    end

    it 'returns the expected co2 scrubber rating' do
      expect(subject).to eq 10
    end
  end

  describe '#life_support_rating' do
    subject do
      reader = BinaryReader.new
      reader.life_support_rating input: input
    end

    it 'returns the expected life support rating' do
      expect(subject).to eq 230
    end
  end
end