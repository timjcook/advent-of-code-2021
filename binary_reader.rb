# frozen_string_literal: true

require_relative 'input_reader'
require "ostruct"
require "pry"

# Generating the power consumption based on the
# given inputs
class BinaryReader
  def gamma_rate(input:)
    bits = build_bits_per_bit_position input: input, find_common_bit: :most_common_bit

    bits_to_decimal bits: bits
  end

  def epsilon_rate(input:)
    bits = build_bits_per_bit_position input: input, find_common_bit: :least_common_bit

    bits_to_decimal bits: bits
  end

  def power_consumption(input:)
    (gamma_rate input: input) * (epsilon_rate input: input)
  end

  def oxygen_generator_rating(input:)
    bits = keep_bits_by_bit_position input: input, find_common_bit: :most_common_bit

    bits_to_decimal bits: bits
  end

  def co2_scrubber_rating(input:)
    bits = keep_bits_by_bit_position input: input, find_common_bit: :least_common_bit

    bits_to_decimal bits: bits
  end

  def life_support_rating(input:)
    (oxygen_generator_rating input: input) * (co2_scrubber_rating input: input)
  end

  private

  def build_bits_per_bit_position(input:, find_common_bit:)
    bits = ''.dup

    bit_counts = bit_counts_for_input(input: input)
    bit_counts.each do |bit_count|
      bits << send(find_common_bit, bit_count: bit_count)
    end

    bits
  end

  def keep_bits_by_bit_position(input:, find_common_bit:)
    bit_counts = []

    remaining_input = input.dup
    iterate_by_bit_position(input: input) do |bit_position|
      bit_counts = bit_counts_for_input input: remaining_input
      bit_count = bit_counts[bit_position]

      remaining_input.filter! do |i|
        i[bit_count.bit_position] == send(find_common_bit, bit_count: bit_count)
      end

      break if remaining_input.length == 1
    end

    remaining_input.first
  end

  def bit_counts_for_input(input:)
    bit_counts = []

    iterate_by_bit_position(input: input) do |index|
      bit_count = create_bit_count input: input, bit_position: index
      bit_counts << bit_count
    end

    bit_counts
  end

  def create_bit_count(input:, bit_position:)
    bit_count = OpenStruct.new(
      bit_position: bit_position,
      zeroes: 0,
      ones: 0
    )

    input.each do |line|
      if line[bit_position] == '0'
        bit_count.zeroes += 1
      else
        bit_count.ones += 1
      end
    end

    bit_count
  end

  def iterate_by_bit_position(input:)
    (0..(input[0].length - 1)).to_a.each do |index|
      yield index
    end
  end

  def bits_to_decimal(bits:)
    bits.to_i(2)
  end

  def most_common_bit(bit_count:)
    bit_count.zeroes > bit_count.ones ? '0' : '1'
  end

  def least_common_bit(bit_count:)
    bit_count.zeroes > bit_count.ones ? '1' : '0'
  end
end
