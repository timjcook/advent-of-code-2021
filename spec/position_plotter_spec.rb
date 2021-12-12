# frozen_string_literal: true

require_relative '../position_plotter'

RSpec.describe PositionPlotter do
  describe 'plot_course' do
    let(:input) do
      [
        'forward 5',
        'down 5',
        'forward 8',
        'up 3',
        'down 8',
        'forward 2'
      ]
    end

    subject do
      plotter = PositionPlotter.new
      plotter.plot_course(input: input)
    end

    it 'calculates the expected horizontal position' do
      expect(subject.horizontal_position).to eq 15
    end

    it 'calculates the expected depth' do
      expect(subject.depth).to eq 10
    end
  end
end

RSpec.describe UpgradedPositionPlotter do
  describe 'plot_course' do
    let(:input) do
      [
        'forward 5',
        'down 5',
        'forward 8',
        'up 3',
        'down 8',
        'forward 2'
      ]
    end

    subject do
      plotter = UpgradedPositionPlotter.new
      plotter.plot_course(input: input)
    end

    it 'calculates the expected horizontal position' do
      expect(subject.horizontal_position).to eq 15
    end

    it 'calculates the expected depth' do
      expect(subject.depth).to eq 60
    end
  end
end