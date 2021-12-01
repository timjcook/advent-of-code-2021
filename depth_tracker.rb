# frozen_string_literal: true

require_relative 'input_reader'

# Looking for the keys to the sleigh on the
# bottom of the ocean by checking change in depth
class DepthTracker
  attr_reader :depth_increases

  def initialize(window_size: 1)
    @depth_increases = 0
    @window_size = window_size
  end

  def analyze(input:)
    depths = calc_depths(input: input)

    @depth_increases = measure_increases(depths: depths)
  end

  private

  attr_reader :window_size

  def measure_increases(depths:)
    increases = 0
    depths.each.with_index do |d, i|
      next if i.zero?

      increases += d > depths[i - 1] ? 1 : 0
    end

    increases
  end

  def calc_depths(input:)
    input.map.with_index do |_, i|
      range = window_range(index: i, input: input)
      next nil unless range.to_a.length == window_size

      window_sum(range: range, input: input)
    end.compact
  end

  def window_sum(range:, input:)
    sum = 0

    range.to_a.each do |n|
      sum += input[n]
    end

    sum
  end

  def window_range(index:, input:)
    (index..([index + window_size - 1, input.length - 1].min))
  end
end

reader = InputReader.new(filename: 'inputs/day-1.txt')

tracker1 = DepthTracker.new(window_size: 1)
tracker1.analyze(input: reader.lines_as_ints)

puts "Number of depth increases: #{tracker1.depth_increases}\n"

tracker3 = DepthTracker.new(window_size: 3)
tracker3.analyze(input: reader.lines_as_ints)

puts "Number of depth increases: #{tracker3.depth_increases}\n"
