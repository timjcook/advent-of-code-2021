require_relative 'input_reader'
require_relative 'depth_tracker'
require_relative 'position_plotter'
require_relative 'binary_reader'
require_relative 'bingo_player'
require_relative 'vent_mapper'
require_relative 'fish_tracker'

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

## Day 4

heading day: 4

reader = InputReader.new(filename: 'inputs/day-4.txt')
bingo = BingoPlayer.new(game: reader.lines)

bingo.play

first_winning_board = bingo.winning_boards.first.board
puts "Winning board:\n #{first_winning_board}\n"
puts "Last sequence number: #{first_winning_board.last_marked_value}\n"
puts "Total: #{first_winning_board.total}\n\n"

last_winning_board = bingo.winning_boards.last.board
puts "Winning board:\n #{last_winning_board}\n"
puts "Last sequence number: #{last_winning_board.last_marked_value}\n"
puts "Total: #{last_winning_board.total}\n\n"

## Day 5

heading day: 5

reader = InputReader.new(filename: 'inputs/day-5.txt')
vent_mapper = VentMapper.new(fields: reader.lines)

puts "Number of overlapping field (without diagonals): #{vent_mapper.num_overlapping_fields}\n"

vent_mapper = VentMapper.new(fields: reader.lines, diagonal: true)
puts "Number of overlapping field (with diagonals): #{vent_mapper.num_overlapping_fields}\n\n"

## Day 6

heading day: 6

reader = InputReader.new(filename: 'inputs/day-6.txt')

num_fish = School.num_fish(input: reader.lines.first, days: 80)
puts "Number of fish (80 days): #{num_fish}\n"

num_fish = School.num_fish(input: reader.lines.first, days: 256)
puts "Number of fish (256 days): #{num_fish}\n\n"
