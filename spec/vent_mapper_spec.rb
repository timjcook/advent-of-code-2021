# frozen_string_literal: true

require_relative '../vent_mapper'

RSpec.describe VentMapper do
  let(:input) do
    [
      '0,9 -> 5,9',
      '8,0 -> 0,8',
      '9,4 -> 3,4',
      '2,2 -> 2,1',
      '7,0 -> 7,4',
      '6,4 -> 2,0',
      '0,9 -> 2,9',
      '3,4 -> 1,4',
      '0,0 -> 8,8',
      '5,5 -> 8,2'
    ]
  end
  let(:diagonal) { false }

  subject do
    VentMapper.new(fields: input, diagonal: diagonal)
  end

  describe '#num_overlapping_fields' do
    context 'without diagonals' do
      it 'returns the expected number' do
        expect(subject.num_overlapping_fields).to eq 5
      end
    end

    context 'with diagonals' do
      let(:diagonal) { true }
      it 'returns the expected number' do
        expect(subject.num_overlapping_fields).to eq 12
      end
    end
  end

  describe '#print_map' do
    context 'without diagonals' do
      it 'returns the expected output' do
        expected_output = ".......1..\n..1....1..\n..1....1..\n.......1..\n.112111211\n..........\n..........\n..........\n..........\n222111....\n" 

        expect(subject.print_map).to eq expected_output
      end
    end

    context 'with diagonals' do
      let(:diagonal) { true }
      it 'returns the expected number' do
        expected_output = "1.1....11.\n.111...2..\n..2.1.111.\n...1.2.2..\n.112313211\n...1.2....\n..1...1...\n.1.....1..\n1.......1.\n222111....\n"
        expect(subject.print_map).to eq expected_output
      end
    end
  end

  describe '#create_field' do
    it 'returns a horizontal field' do
      result = subject.create_field field: '9,4 -> 3,4'

      expect(result).to eq [
        Point.new(x: 3, y: 4),
        Point.new(x: 4, y: 4),
        Point.new(x: 5, y: 4),
        Point.new(x: 6, y: 4),
        Point.new(x: 7, y: 4),
        Point.new(x: 8, y: 4),
        Point.new(x: 9, y: 4)
      ]
    end

    it 'returns a vertical field' do
      result = subject.create_field field: '7,0 -> 7,4'

      expect(result).to eq [
        Point.new(x: 7, y: 0),
        Point.new(x: 7, y: 1),
        Point.new(x: 7, y: 2),
        Point.new(x: 7, y: 3),
        Point.new(x: 7, y: 4)
      ]
    end

    it 'returns a trending down diagonal field' do
      result = subject.create_field field: '1,1 -> 5,5', diagonal: true

      expect(result).to eq [
        Point.new(x: 1, y: 1),
        Point.new(x: 2, y: 2),
        Point.new(x: 3, y: 3),
        Point.new(x: 4, y: 4),
        Point.new(x: 5, y: 5)
      ]
    end

    it 'returns a reverse trending down diagonal field' do
      result = subject.create_field field: '5,5 -> 1,1', diagonal: true

      expect(result).to eq [
        Point.new(x: 1, y: 1),
        Point.new(x: 2, y: 2),
        Point.new(x: 3, y: 3),
        Point.new(x: 4, y: 4),
        Point.new(x: 5, y: 5)
      ]
    end

    it 'returns a trending down diagonal field' do
      result = subject.create_field field: '1,4 -> 4,1', diagonal: true

      expect(result).to eq [
        Point.new(x: 1, y: 4),
        Point.new(x: 2, y: 3),
        Point.new(x: 3, y: 2),
        Point.new(x: 4, y: 1)
      ]
    end
  end
end