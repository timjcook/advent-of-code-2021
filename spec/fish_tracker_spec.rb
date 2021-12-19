# frozen_string_literal: true

require_relative '../fish_tracker'

RSpec.describe School do
  let(:input) { '3,4,3,1,2' }
  let(:days) { 80 }

  subject do
    School.num_fish(input: input, days: days)
  end

  describe '#simulate_days' do
    let(:days) { 18 }

    it 'returns the expected number of fish' do
      expect(subject).to eq 26
    end

    context '80 days' do
      let(:days) { 80 }
      it 'returns the expected number of fish' do
        expect(subject).to eq 5934
      end
    end

    context '256 days' do
      let(:days) { 256 }
      it 'returns the expected number of fish' do
        expect(subject).to eq 26_984_457_539
      end
    end
  end
end
