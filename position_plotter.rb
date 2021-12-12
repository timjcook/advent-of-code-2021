# frozen_string_literal: true

require "ostruct"

class PositionPlotter
  def plot_course(input:)
    horizontal_position = 0
    depth = 0

    instructions = read_instructions(input: input)
    process_instructions(instructions: instructions)
  end

  private

  attr_reader :instructions

  def read_instructions(input:)
    input.map do |line|
      line_split = line.split ' '

      instruction = line_split[0].to_sym
      value = line_split[1].to_i

      OpenStruct.new(
        instruction: instruction,
        value: value
      )
    end
  end

  def process_instructions(instructions:)
    @horizontal_position = 0
    @depth = 0

    instructions.each do |i|
      case i.instruction
      when :forward
        process_forward value: i.value
      when :up
        process_up value: i.value
      when :down
        process_down value: i.value
      end
    end

    OpenStruct.new({
      horizontal_position: @horizontal_position,
      depth: @depth
    })
  end

  def process_forward(value:)
    @horizontal_position += value
  end

  def process_up(value:)
    @depth -= value
  end

  def process_down(value:)
    @depth += value
  end
end

class UpgradedPositionPlotter < PositionPlotter
  def process_instructions(instructions:)
    @aim = 0
    super instructions: instructions
  end

  def process_forward(value:)
    @horizontal_position += value
    @depth += @aim * value
  end

  def process_up(value:)
    @aim -= value
  end

  def process_down(value:)
    @aim += value
  end
end
