# frozen_string_literal: true

require 'ostruct'

class FuelCalculator
  def initialize(input:, burn_rate:)
    @burn_rate = burn_rate
    @crabs = (input.split ',').map do |position|
      Crab.new position: position.to_i
    end

    @fuel_lookup = {}
  end

  class << self
    def optimal_position_for_linear_burn_rate(input:)
      calculator = new input: input, burn_rate: :linear
      calculator.optimal_position
    end

    def optimal_position_for_increasing_burn_rate(input:)
      calculator = new input: input, burn_rate: :increasing
      calculator.optimal_position
    end
  end

  attr_reader :crabs, :burn_rate

  def optimal_position
    fuel_usages = []
    iterate_positions do |position|
      fuel_usages << OpenStruct.new(
        position: position,
        fuel_usage: (fuel_usage_for_position position: position),
      )
    end

    fuel_usages.sort_by { |u| u.fuel_usage }.first
  end

  private

  attr_reader :fuel_lookup

  def fuel_usage_for_position(position:)
    fuel_usage_per_crab = crabs.map do |crab|
      burn_rate_method = burn_rate == :linear ? :linear_burn_rate : :increasing_burn_rate
      fuel_usage_for_crab_move crab: crab, position: position, burn_rate_method: burn_rate_method
    end
    fuel_usage_per_crab.sum
  end

  def fuel_usage_for_crab_move(crab:, position:, burn_rate_method:)
    send burn_rate_method, crab.position, position
  end

  def max_position
    (crabs.sort_by { |c| c.position }).last.position
  end

  def iterate_positions
    (0..max_position).each do |position|
      yield position
    end
  end

  def linear_burn_rate(start_position, finish_position)
    (start_position - finish_position).abs
  end

  def increasing_burn_rate(start_position, finish_position)
    steps = (start_position - finish_position).abs

    return fuel_lookup[steps] unless fuel_lookup[steps].nil?

    fuel = (1..steps).to_a.sum
    fuel_lookup[steps] = fuel

    fuel
  end
end

class Crab
  def initialize(position:)
    @position = position
  end

  attr_reader :position
end
