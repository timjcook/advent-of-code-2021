# frozen_string_literal: true

require_relative '../lavaflow_monitor'

RSpec.describe LavaflowMonitor do
  let(:input) do
    [
      '2199943210',
      '3987894921',
      '9856789892',
      '8767896789',
      '9899965678'
    ]
  end

  describe '#risk_assessment' do
    subject do
      LavaflowMonitor.risk_assessment input: input
    end

    it 'calculates the expected risk assessment' do
      expect(subject).to eq 15
    end
  end

  describe '#basin_score' do
    subject do
      LavaflowMonitor.basin_score input: input
    end

    it 'calculates the expected basin score' do
      expect(subject).to eq 1134
    end
  end
end
