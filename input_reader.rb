# frozen_string_literal: true

# Provides methods for reading input from a file
# and returning as an array.
class InputReader
  attr_reader :lines

  def initialize(filename:)
    @lines = File.read(filename).split("\n")
  end

  def lines_as_ints
    @lines.map(&:to_i)
  end
end
