# frozen_string_literal: true

require 'pry'

class OctopusCounter 
  def initialize(lines:)
    @lines = lines
    @flash_count = 0

    @state = []
    lines.each.with_index do |line, y|
      @state << []
      line.chars.each.with_index do |octopus, x|
        @state.last << (Octopus.new initial_energy_level: octopus.to_i, x: x, y: y)
      end
    end
  end

  class << self
    def flash_count(lines:, steps:)
      counter = new lines: lines
      counter.flash_count steps: steps
    end

    def sync_step(lines:)
      counter = new lines: lines
      counter.sync_step
    end
  end

  def flash_count(steps:)
    state_after_steps steps: steps

    @flash_count
  end

  def sync_step
    step = 0

    while !state_in_sync?
      step += 1
      run_step
    end

    step
  end

  def state_after_steps(steps:)
    (0..(steps - 1)).each do |step|
      run_step
    end

    state.map do |line|
      line.map { |oct| oct.energy_level }.join
    end
  end

  private

  attr_reader :lines, :steps, :state

  def state_in_sync?
    state.flatten.all? { |o| o.energy_level == 0 }
  end

  def run_step
    iterate_octopus do |octopus|
      octopus.power_up
      check_flash octopus: octopus
    end

    @flash_count += state.flatten.filter { |o| o.flashed }.length

    iterate_octopus do |octopus|
      octopus.reset
    end
  end

  def check_flash(octopus:)
    if octopus.energy_level > 9
      octopus.flash
      (adjacent_octopus octopus: octopus).each do |o|
        o.power_up
        check_flash octopus: o
      end

      return true
    end
  end

  def iterate_octopus
    state.each do |l|
      l.each do |octopus|
        yield octopus
      end
    end
  end

  def adjacent_octopus(octopus:)
    [
      top_left(octopus: octopus),
      top(octopus: octopus),
      top_right(octopus: octopus),
      mid_left(octopus: octopus),
      mid_right(octopus: octopus),
      bottom_left(octopus: octopus),
      bottom(octopus: octopus),
      bottom_right(octopus: octopus)
    ].compact
  end

  def top_left(octopus:)
    return nil if octopus.y - 1 < min_y || octopus.x - 1 < min_x

    state[octopus.y - 1][octopus.x - 1]
  end

  def top(octopus:)
    return nil if octopus.y - 1 < min_y

    state[octopus.y - 1][octopus.x]
  end

  def top_right(octopus:)
    return nil if octopus.y - 1 < min_y || octopus.x + 1 > max_x

    state[octopus.y - 1][octopus.x + 1]
  end

  def mid_left(octopus:)
    return nil if octopus.x - 1 < min_x

    state[octopus.y][octopus.x - 1]
  end

  def mid_right(octopus:)
    return nil if octopus.x + 1 > max_x

    state[octopus.y][octopus.x + 1]
  end

  def bottom_left(octopus:)
    return nil if octopus.y + 1 > max_y || octopus.x - 1 < min_x

    state[octopus.y + 1][octopus.x - 1]
  end

  def bottom(octopus:)
    return nil if octopus.y + 1 > max_y

    state[octopus.y + 1][octopus.x]
  end

  def bottom_right(octopus:)
    return nil if octopus.y + 1 > max_y || octopus.x + 1 > max_x

    state[octopus.y + 1][octopus.x + 1]
  end

  def min_x
    0
  end

  def min_y
    0
  end

  def max_x
    state[0].length - 1
  end

  def max_y
    state.length - 1
  end
end

class Octopus
  def initialize(initial_energy_level:, x:, y:)
    @energy_level = initial_energy_level
    @x = x
    @y = y
    @flashed = false
  end

  attr_reader :energy_level, :x, :y, :flashed

  def power_up
    @energy_level += 1 unless flashed
  end

  def flash
    @energy_level = 0
    @flashed = true
  end

  def reset
    @flashed = false
  end

  def to_s
    energy_level
  end
end
