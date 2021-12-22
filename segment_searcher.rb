# frozen_string_literal: true

require 'pry'

class SegmentSearcher
  def initialize(input:)
    @trackers = []

    input.each do |line|
      tracker = SegmentTracker.new(line: line)
      @trackers << tracker
    end
  end

  class << self
    def num_identified_outputs(input:)
      (new input: input).num_identified_outputs
    end

    def sum_output_values(input:)
      (new input: input).sum_output_values
    end
  end

  attr_reader :trackers

  def num_identified_outputs
    trackers.flat_map(&:identified_output_signals).length
  end

  def sum_output_values
    trackers.map(&:output_value).sum
  end
end

class SegmentTracker
  def initialize(line:)
    @input_signals = []
    @output_signals = []

    @input_values = []
    @output_values = []

    initialize_variables

    signals, outputs = line.split '|'

    (signals.split ' ').each do |s|
      @input_signals << (SignalCode.new value: (normalize_signal signal: s))
    end
    (outputs.split ' ').each do |s|
      @output_signals << (SignalCode.new value: (normalize_signal signal: s))
    end

    decrypt_signals

    @input_values = input_signals.map { |s| map_signal_to_value signal: s }
    @output_values = output_signals.map { |s| map_signal_to_value signal: s }
  end

  def output_value
    output_values.join.to_i
  end

  def identified_output_signals
    output_signals.select(&:identified?)
  end

  attr_reader :input_signals, :output_signals, :input_values, :output_values

  private

  LETTERS = %w[a b c d e f g].freeze

  attr_reader :zero, :one, :two, :three, :four, :five, :six, :seven, :eight, :nine,
              :top_left, :top, :top_right, :middle, :bottom_left, :bottom, :bottom_right

  def map_signal_to_value(signal:)
    case signal.value
    when zero.value
      0
    when one.value
      1
    when two.value
      2
    when three.value
      3
    when four.value
      4
    when five.value
      5
    when six.value
      6
    when seven.value
      7
    when eight.value
      8
    when nine.value
      9
    end
  end

  def normalize_signal(signal:)
    signal.chars.sort.join
  end

  def decrypt_signals
    @one = find_one
    @four = find_four
    @seven = find_seven
    @eight = find_eight
    @two = find_two

    @bottom_right = find_bottom_right
    @top_right = find_top_right
    @top = find_top
    @top_left = find_top_left
    @middle = find_middle

    @six = find_six
    @nine = find_nine
    @zero = find_zero

    @bottom_left = find_bottom_left
    @bottom = find_bottom

    @three = find_three
    @five = find_five
  end


  def find_zero
    return nil if six.nil? || nine.nil?

    input_signals.select { |signal| signal.value.length == 6 && !([six.value, nine.value].include? signal.value) }.first
  end

  def find_one
    input_signals.select { |signal| signal.value.length == 2 }.first
  end

  def find_two
    return nil if one.nil?

    seg1, seg2 = one.value.chars

    no_seg1s = input_signals.reject { |signal| signal.value.include? seg1 }
    no_seg2s = input_signals.reject { |signal| signal.value.include? seg2 }

    return no_seg1s[0] if no_seg1s.length == 1

    no_seg2s[0]
  end

  def find_three
    return nil if [top_right, top, middle, bottom, bottom_right].any? nil

    input_signals.select do |signal|
      signal.value == [top_right, top, middle, bottom, bottom_right].sort.join
    end.first
  end

  def find_four
    input_signals.select { |signal| signal.value.length == 4 }.first
  end

  def find_five
    return nil if [top_left, top, middle, bottom, bottom_right].any? nil

    input_signals.select do |signal|
      signal.value.chars.all? do |char|
        [top_left, top, middle, bottom, bottom_right].include? char
      end
    end.first
  end

  def find_six
    return nil if top_right.nil?

    input_signals.select { |signal| signal.value.length == 6 && !(signal.value.chars.include? top_right) }.first
  end

  def find_seven
    input_signals.select { |signal| signal.value.length == 3 }.first
  end

  def find_eight
    input_signals.select { |signal| signal.value.length == 7 }.first
  end

  def find_nine
    return nil if [top_right, top_left, top, middle, bottom_right].any? nil

    input_signals.select do |signal|
      signal.value.length == 6 &&
        signal.value.chars.reject do |char|
          [top_left, top_right, top, bottom_right, middle].include? char
        end.length == 1
    end.first
  end

  def find_top
    return nil if [seven, top_right, bottom_right].any? nil

    seven.value.chars.reject do |char|
      [top_right, bottom_right].include? char
    end.first
  end

  def find_top_left
    return nil if [two, bottom_right].any? nil

    LETTERS.reject { |char| (two.value.include? char) || char == bottom_right }.first
  end

  def find_top_right
    return nil if [one, bottom_right].any? nil

    one.value.chars.reject { |char| char == bottom_right }.first
  end

  def find_middle
    return nil if [four, top_left, top_right, bottom_right].any? nil

    four.value.chars.reject { |signal| [top_left, top_right, bottom_right].include? signal }.first
  end

  def find_bottom
    return nil if [top_left, top_right, top, middle, bottom_left, bottom_right].any? nil

    LETTERS.reject do |char|
      [top_left, top, top_right, middle, bottom_left, bottom_right].include? char
    end.first
  end

  def find_bottom_left
    return nil if nine.nil?

    LETTERS.reject { |char| nine.value.include? char }.first
  end

  def find_bottom_right
    return nil if one.nil? || two.nil?

    one.value.chars.reject { |char| two.value.chars.include? char }.first
  end

  def initialize_variables
    @top_left = nil
    @top = nil
    @top_right = nil
    @middle = nil
    @bottom_left = nil
    @bottom = nil
    @bottom_right = nil

    @one = nil
    @two = nil
    @three = nil
    @four = nil
    @five = nil
    @six = nil
    @seven = nil
    @eight = nil
    @nine = nil
  end
end

class SignalCode
  def initialize(value:)
    @value = value
  end

  attr_reader :value

  def identified?
    !status.nil?
  end

  def status
    case value.length
    when 2
      'one'
    when 3
      'seven'
    when 4
      'four'
    when 7
      'eight'
    end
  end
end
