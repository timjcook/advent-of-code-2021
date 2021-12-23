# frozen_string_literal: true

require 'pry'
require 'set'

class LavaflowMonitor
  def initialize(input:)
    @points = input.map.with_index do |line, y|
      line.chars.map.with_index do |value, x|
        LavaPoint.new x: x, y: y, value: value.to_i
      end
    end

    @low_points = find_low_points
    @basins = find_basins
  end

  class << self
    def risk_assessment(input:)
      monitor = new input: input
      monitor.risk_assessment
    end

    def basin_score(input:)
      monitor = new input: input
      monitor.basin_score
    end
  end

  def risk_assessment
    low_points.map { |lp| lp.value + 1 }.sum
  end

  def basin_score
    @basins.map(&:length).sort.reverse.slice(0, 3).inject(:*)
  end

  private

  attr_reader :points, :low_points

  def find_basins
    low_points.map do |lp|
      find_basin low_point: lp
    end
  end

  def find_basin(low_point:)
    basin = Set.new([low_point])

    find_points_in_basin point: low_point, basin: basin
  end

  def find_points_in_basin(point:, basin:)
    adjacent_basin_points = (adjacent_points x: point.x, y: point.y).select do |p|
      p.in_basin? && !(basin.include? p)
    end

    return if adjacent_basin_points.empty?

    adjacent_basin_points.each do |adj_point|
      basin << adj_point
    end

    adjacent_basin_points.each do |adj_point|
      find_points_in_basin point: adj_point, basin: basin
    end

    basin
  end

  def find_low_points
    low_points = []

    iterate_points do |point|
      low_points << point if low_point? x: point.x, y: point.y
    end

    low_points
  end

  def low_point?(x:, y:)
    (adjacent_points x: x, y: y).all? do |adjacent_point|
      adjacent_point.value > (point x: x, y: y).value
    end
  end

  def adjacent_points(x:, y:)
    [
      (up_point x: x, y: y),
      (down_point x: x, y: y),
      (left_point x: x, y: y),
      (right_point x: x, y: y)
    ].compact
  end

  def point(x:, y:)
    points[y][x]
  end

  def up_point(x:, y:)
    return nil if y == 0

    points[y - 1][x]
  end

  def down_point(x:, y:)
    return nil if y == points.length - 1

    points[y + 1][x]
  end

  def left_point(x:, y:)
    return nil if x == 0

    points[y][x - 1]
  end

  def right_point(x:, y:)
    return nil if x == points[0].length - 1

    points[y][x + 1]
  end

  def iterate_points
    points.each do |line|
      line.each do |point|
        yield point
      end
    end
  end
end

class LavaPoint
  def initialize(x:, y:, value:)
    @x = x
    @y = y
    @value = value
  end

  attr_reader :x, :y, :value

  def in_basin?
    value < 9
  end
end