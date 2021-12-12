require_relative 'input_reader'
require_relative 'depth_tracker'
require_relative 'position_plotter'

def heading(day:)
  puts "===========================================\n"
  puts "Day #{day}\n"
  puts "===========================================\n\n"
end

## Day 1

heading day: 1

reader = InputReader.new(filename: 'inputs/day-1.txt')

tracker1 = DepthTracker.new(window_size: 1)
tracker1.analyze(input: reader.lines_as_ints)

puts "Number of depth increases: #{tracker1.depth_increases}\n"

tracker3 = DepthTracker.new(window_size: 3)
tracker3.analyze(input: reader.lines_as_ints)

puts "Number of depth increases: #{tracker3.depth_increases}\n\n"

## Day 2

heading day: 2

reader = InputReader.new(filename: 'inputs/day-2.txt')

plotter = PositionPlotter.new
position = plotter.plot_course(input: reader.lines)

puts "Horizontal position: #{position.horizontal_position}"
puts "Depth: #{position.depth}"

puts "Product: #{position.depth * position.horizontal_position}\n\n"

upgraded_plotter = UpgradedPositionPlotter.new
position = upgraded_plotter.plot_course(input: reader.lines)

puts "Horizontal position: #{position.horizontal_position}"
puts "Depth: #{position.depth}"

puts "Product: #{position.depth * position.horizontal_position}\n\n"