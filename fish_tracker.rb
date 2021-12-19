# frozen_string_literal: true

require 'pry'

class School
  class << self
    def num_fish(input:, days:)
      school = (new input: input)
      school.num_fish days: days
    end
  end

  attr_reader :fish

  def initialize(input:)
    @fish = []
    fish_data = (input.split ',').map &:to_i

    fish_data.each do |f|
      @fish << (Fish.new initial_days: f, day_created: 0)
    end
  end

  def num_fish(days:)
    spawner = FishSpawner.new

    fish.length + fish.reduce(0) do |count, f|
      count + (spawner.num_spawn_for_fish fish: f, days: days)
    end
  end
end

class Fish
  def initialize(initial_days:, day_created:)
    @initial_days = initial_days
    @day_created = day_created
  end

  class << self
    def spawn(day_created:)
      new initial_days: 8, day_created: day_created
    end
  end

  def key
    "#{day_created},#{initial_days}"
  end

  def to_s
    "Days: #{initial_days}, Created: #{day_created}"
  end

  attr_reader :initial_days, :day_created
end

class FishSpawner
  def initialize
    @spawn_patterns = {}
    @spawn_counts = {}
  end

  def num_spawn_for_fish(fish:, days:)
    spawn_days = calc_spawn_days fish: fish, days: days

    return 0 if spawn_days.empty?
    return spawn_counts[fish.key] unless spawn_counts[fish.key].nil?

    new_fish = spawn_days.map do |d|
      Fish.spawn day_created: d
    end

    num_child_fish = new_fish.map do |f|
      num_spawn_for_fish fish: f, days: days
    end.sum

    num = num_child_fish + new_fish.length
    spawn_counts[fish.key] = num

    num
  end

  private

  attr_reader :spawn_patterns, :spawn_counts

  def calc_spawn_days(fish:, days:)
    return spawn_patterns[fish.key] unless spawn_patterns[fish.key].nil?

    day = fish.day_created
    spawn_days = []

    spawn_day = day + fish.initial_days + 1

    return spawn_days if spawn_day > days

    spawn_days << spawn_day
    day += fish.initial_days + 1

    while day + 7 <= days
      spawn_day = day + 7

      spawn_days << spawn_day
      day += 7
    end

    spawn_patterns[fish.key] = spawn_days

    spawn_days
  end
end
