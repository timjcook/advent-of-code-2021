# frozen_string_literal: true

require 'pry'

class CaveMapper
  def initialize(input:, allow_small_cave_return: false)
    @input = input
    @cave_system = CaveSystem.new(connections: input, allow_small_cave_return: allow_small_cave_return)
  end

  class << self
    def num_paths(input:, allow_small_cave_return: false)
      mapper = new input: input, allow_small_cave_return: allow_small_cave_return
      mapper.num_paths
    end
  end

  attr_reader :cave_system

  def num_paths
    paths.length
  end

  def paths
    cave_system.paths
  end
end

class CaveSystem
  def initialize(connections:, allow_small_cave_return:)
    @caves = Set.new []
    @connections = Set.new []
    @allow_small_cave_return = allow_small_cave_return

    connections.each do |connection|
      cave_name_a, cave_name_b = connection.split '-'

      cave_a = if cave_exists? name: cave_name_a
                 find_cave name: cave_name_a
               else
                 new_cave = create_cave name: cave_name_a
                 @caves << new_cave
                 new_cave
               end

      cave_b = if cave_exists? name: cave_name_b
                 find_cave name: cave_name_b
               else
                 new_cave = create_cave name: cave_name_b
                 @caves << new_cave
                 new_cave
               end

      create_connection cave_a: cave_a, cave_b: cave_b
    end

    start_cave = find_cave name: Cave::START_CAVE

    @paths = find_path(cave: start_cave, current_path: [], paths: [])
  end

  attr_reader :caves, :connections, :paths, :allow_small_cave_return

  def find_path(cave:, current_path:, paths:)
    # return path if we reach the end
    if cave.end?
      new_path = current_path.dup << cave
      paths << new_path
      return 
    end

    # return nil if we go back to the start
    return if cave.start? && (current_path.map(&:name).include? Cave::START_CAVE)

    # return nil if we go back to a small cave
    if cave.small?
      small_cave_dead_end = current_path.include? cave

      # return nil if we have already gone to another small cave twice or more
      if allow_small_cave_return
        small_cave_dead_end = small_cave_dead_end && current_path.any? do |cave|
          cave.small? && current_path.filter { |c| c == cave }.length >= 2
        end
      end

      return if small_cave_dead_end
    end

    new_path = current_path.dup << cave
    connections = find_connection_for_cave cave: cave

    connections.map do |conn|
      cave_1, cave_2 = conn

      if cave_1 == cave
        find_path cave: cave_2, current_path: new_path, paths: paths
      else
        find_path cave: cave_1, current_path: new_path, paths: paths
      end
    end

    return paths
  end

  def find_cave(name:)
    caves.find { |cave| cave.name == name }
  end

  def cave_exists?(name:)
    !(find_cave name: name).nil?
  end

  def create_cave(name:)
    Cave.new name: name
  end

  def create_connection(cave_a:, cave_b:)
    @connections << [cave_a, cave_b]
  end

  def find_connection_for_cave(cave:)
    connections.filter do |conn|
      conn[0] == cave || conn[1] == cave
    end
  end
end

class Cave
  def initialize(name:)
    @name = name
  end

  attr_reader :name

  START_CAVE = 'start'.freeze
  END_CAVE = 'end'.freeze

  def large?
    name.upcase == name
  end

  def small?
    !large?
  end

  def start?
    name == START_CAVE
  end

  def end?
    name == END_CAVE
  end
end
