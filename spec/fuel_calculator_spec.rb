# frozen_string_literal: true

require_relative '../fuel_calculator'

RSpec.describe FuelCalculator do
  let(:input) do
    '16,1,2,0,4,2,7,1,2,14'
  end

  describe '#optimal_position_for_linear_burn_rate' do
    subject do
      FuelCalculator.optimal_position_for_linear_burn_rate input: input
    end

    it 'calculates the expected position' do
      expect(subject.position).to eq 2
    end

    it 'calculates the expected fuel usage' do
      expect(subject.fuel_usage).to eq 37
    end
  end

  describe '#optimal_position_for_increasing_burn_rate' do
    subject do
      FuelCalculator.optimal_position_for_increasing_burn_rate input: input
    end

    it 'calculates the expected position' do
      expect(subject.position).to eq 5
    end

    it 'calculates the expected fuel usage' do
      expect(subject.fuel_usage).to eq 168
    end
  end
end
