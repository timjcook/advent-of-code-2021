# frozen_string_literal: true

require_relative '../bingo_player'

RSpec.describe BingoPlayer do
  let(:input) do
    [
      '7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1',
      '',
      '22 13 17 11  0',
      ' 8  2 23  4 24',
      '21  9 14 16  7',
      ' 6 10  3 18  5',
      ' 1 12 20 15 19',
      '',
      ' 3 15  0  2 22',
      ' 9 18 13 17  5',
      '19  8  7 25 23',
      '20 11 10 24  4',
      '14 21 16 12  6',
      '',
      '14 21 17 24  4',
      '10 16 15  9 19',
      '18  8 23 26 20',
      '22 11 13  6  5',
      ' 2  0 12  3  7'
    ]
  end

  subject do
    bingo = BingoPlayer.new(game: input)
    bingo.play

    bingo
  end

  describe '#winning_board' do
    it 'returns the expected board' do
      expect(subject.winning_boards.first.board).to eq subject.boards[2]
    end
  end
end

RSpec.describe BingoBoard do
  let(:input) do
    [
      '14 21 17 24  4',
      '10 16 15  9 19',
      '18  8 23 26 20',
      '22 11 13  6  5',
      ' 2  0 12  3  7'
    ]
  end

  subject do
    BingoBoard.new(lines: input, grid_size: 5)
  end

  describe '#mark_number' do
    let(:number) { subject.send(:position, x: 3, y: 4) }

    it 'marks a number as called' do
      expect(number.marked).to eq false

      subject.mark_number(value: 3)

      expect(number.marked).to eq true
    end
  end

  describe '#score' do
    before do
      [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0, 24].each do |value|
        subject.mark_number(value: value)
      end
    end
    
    it 'returns the expected score' do
      expect(subject.score).to eq 188
    end
  end

  describe '#winning?' do
    context 'is winning board horizontal' do
      before do
        [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0, 24].each do |value|
          subject.mark_number(value: value)
        end
      end

      it 'returns the expected result' do
        expect(subject.winning?).to eq true
      end
    end

    context 'is winning board vertical' do
      before do
        [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0, 10, 18, 22].each do |value|
          subject.mark_number(value: value)
        end
      end

      it 'returns the expected result' do
        expect(subject.winning?).to eq true
      end
    end

    context 'is not winning board' do
      before do
        [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0].each do |value|
          subject.mark_number(value: value)
        end
      end

      it 'returns the expected result' do
        expect(subject.winning?).to eq false
      end
    end
  end

  describe '#last_marked_value' do
    before do
      [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0, 24].each do |value|
        subject.mark_number(value: value)
      end
    end

    it 'returns the expected value' do
      expect(subject.last_marked_value).to eq 24
    end
  end

  describe '#total' do
    before do
      [14, 21, 17, 7, 4, 9, 23, 11, 5, 2, 0, 24].each do |value|
        subject.mark_number(value: value)
      end
    end

    it 'returns the expected value' do
      expect(subject.total).to eq 4512
    end
  end
end