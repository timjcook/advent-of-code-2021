# frozen_string_literal: true

require_relative '../depth_tracker'

RSpec.describe DepthTracker do
  let(:input) do
    [
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263
    ]
  end
  let(:window_size) { 1 }

  subject do
    DepthTracker.new(window_size: window_size)
  end
  before do
    subject.analyze(input: input)
  end

  describe 'track increase' do
    context 'window size 1' do
      it 'finds the expected number of increases' do
        expect(subject.depth_increases).to eq 7
      end
    end

    context 'window size above 1' do
      let(:window_size) { 3 }
      let(:input) do
        [
          199,
          200,
          208,
          210,
          200,
          207,
          240,
          269,
          260,
          263
        ]
      end

      it 'finds the expected number of increases' do
        expect(subject.depth_increases).to eq 5
      end
    end
  end
end
