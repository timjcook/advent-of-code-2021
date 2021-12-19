# frozen_string_literal: true

require 'ostruct'
require 'pry'

class VentMapper
  def initialize(fields:, diagonal: false)
    @fields = (fields.map { |field| create_field field: field, diagonal: diagonal }).compact
    @floor_map = generate_floor_map
  end

  def num_overlapping_fields
    floor_map.flatten.filter { |value| value >= 2 }.length
  end

  def print_map
    floor_map.reduce(''.dup) do |str, row|
      str << row.reduce(''.dup) do |s, value|
        if value == 0
          s << '.'
          next s
        end

        s << value.to_s
      end
      str << "\n"
    end
  end

  def create_field(field:, diagonal: false)
    points = field.split '->'

    point_1_coords = (points[0].strip.split ',').map &:to_i
    point_2_coords = (points[1].strip.split ',').map &:to_i

    point_1 = Point.new(x: point_1_coords[0], y: point_1_coords[1])
    point_2 = Point.new(x: point_2_coords[0], y: point_2_coords[1])

    if point_1.x == point_2.x
      create_vertical_field point_1: point_1, point_2: point_2
    elsif point_1.y == point_2.y
      create_horizonal_field point_1: point_1, point_2: point_2
    elsif diagonal
      create_diagonal_field point_1: point_1, point_2: point_2
    end
  end

  private

  attr_reader :fields, :floor_map

  def generate_floor_map
    floor_map = (0..max_y).map do |y|
                 Array.new(max_x + 1, 0)
               end

    flat_fields.each do |field|
      floor_map[field.y][field.x] += 1
    end

    floor_map
  end

  def flat_fields
    @flat_fields ||= fields.flatten
  end

  def max_x
    @max_x ||= (flat_fields.sort_by { |field| field.x }.reverse.first).x
  end

  def max_y
    @max_y ||= (flat_fields.sort_by { |field| field.y }.reverse.first).y
  end

  def create_horizonal_field(point_1:, point_2:)
    if point_1.x <= point_2.x
      start_point = point_1
      end_point = point_2
    else
      start_point = point_2
      end_point = point_1
    end

    points = (start_point.x..end_point.x)

    points.map do |point|
      Point.new(x: point, y: point_1.y)
    end
  end

  def create_vertical_field(point_1:, point_2:)
    if point_1.y <= point_2.y
      start_point = point_1
      end_point = point_2
    else
      start_point = point_2
      end_point = point_1
    end

    points = (start_point.y..end_point.y)

    points.map do |point|
      Point.new(x: point_1.x, y: point)
    end
  end

  def create_diagonal_field(point_1:, point_2:)
    if point_1.x <= point_2.x
      start_point = point_1
      end_point = point_2
    else
      start_point = point_2
      end_point = point_1
    end

    points = (start_point.x..end_point.x)
    trending_down = start_point.y > end_point.y

    points.map.with_index do |point, index|
      y_adjust = trending_down ? index * -1 : index

      Point.new(x: point, y: start_point.y + y_adjust)
    end
  end
end

class Point
  def initialize(x:, y:)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def ==(point)
    x == point.x && y == point.y
  end
end