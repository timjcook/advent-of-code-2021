require_relative 'input_reader'
require_relative 'depth_tracker'
require_relative 'position_plotter'
require_relative 'binary_reader'

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

## Day 3

heading day: 3

reader = InputReader.new(filename: 'inputs/day-3.txt')

binary_reader = BinaryReader.new
gamma = binary_reader.gamma_rate(input: reader.lines)
epsilon = binary_reader.epsilon_rate(input: reader.lines)
power_consumption = binary_reader.power_consumption(input: reader.lines)
oxygen_generator_rating = binary_reader.oxygen_generator_rating(input: reader.lines)
co2_scrubber_rating = binary_reader.co2_scrubber_rating(input: reader.lines)
life_support_rating = binary_reader.life_support_rating(input: reader.lines)

puts "Gamma rate: #{gamma}"
puts "Epsilon rate: #{epsilon}"
puts "Power consumption: #{power_consumption}\n\n"
puts "Oxygen generator rating: #{oxygen_generator_rating}"
puts "CO2 scrubber rating: #{co2_scrubber_rating}"
puts "Life support rating: #{life_support_rating}\n\n"