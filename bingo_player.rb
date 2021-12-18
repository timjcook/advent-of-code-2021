# frozen_string_literal: true

require 'ostruct'
require 'pry'

class BingoPlayer
  def initialize(game:)
    @number_sequence = ((game.slice! 0).split ',').map { |number| number.to_i }
    @winning_boards = []

    board_inputs = []

    game.each do |line|
      if line == ''
        board_inputs << []
      else
        board_inputs.last.push line
      end
    end

    @boards = board_inputs.map { |input| BingoBoard.new(lines: input, grid_size: 5) }
  end
  
  attr_reader :boards, :winning_boards

  def play
    number_sequence.each do |value|
      boards.each do |board|
        next if board.winning?

        board.mark_number value: value

        if board.winning?
          @winning_boards << OpenStruct.new(
            board: board,
            sequence_value: value
          )
        end
      end
    end
  end

  private

  attr_reader :number_sequence
end

class BingoBoard
  def initialize(lines:, grid_size:)
    @grid_size = grid_size
    @marked_values = []
    @rows = lines.map.with_index do |line, y|
      line.split(' ').map.with_index do |value, x|
        OpenStruct.new(
          x: x,
          y: y,
          value: value.to_i,
          marked: false
        )
      end
    end
  end

  attr_reader :marked_values

  def to_s
    @rows.reduce(''.dup) do |line, row|
      line << row.reduce(''.dup) do |str, number|
        if number.marked
          str << "(#{number.value}) "
        else
          str << " #{number.value}  "
        end
      end   
      line << "\n"
    end
  end

  def winning?
    # check rows
    return true if rows.reduce(false) do |winning, row|
                  winning || row.all? { |value| value.marked } 
                end


    # check columns
    (0..(grid_size - 1)).reduce(false) do |winning, row|
      winning || (0..(grid_size - 1)).reduce(true) do |w, column|
        w && (position x: row, y: column).marked
      end
    end
  end

  def score
    score = 0
    rows.each do |row|
      row.each do |number|
        score += number.value unless number.marked
      end
    end

    score
  end

  def last_marked_value
    marked_values.last 
  end

  def total
    last_marked_value * score
  end

  def mark_number(value:)
    number = find_number_by_value value: value

    unless number.nil?
      number.marked = true
      marked_values << value
    end
  end

  private

  attr_reader :rows, :grid_size

  def find_number_by_value(value:)
    rows.each do |row|
      row.each do |number|
        return number if number.value == value
      end
    end

    nil
  end

  def position(x:, y:)
    rows[y][x]
  end
end