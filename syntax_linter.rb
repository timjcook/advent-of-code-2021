# frozen_string_literal: true

class SyntaxLinter
  def initialize(lines:)
    @syntax_lines = lines.map { |line| SyntaxLine.new line: line }
  end

  class << self
    def illegal_close_score(lines:)
      linter = new lines: lines
      linter.illegal_close_score
    end

    def autocomplete_score(lines:)
      linter = new lines: lines
      linter.autocomplete_score
    end
  end

  def illegal_close_score
    syntax_lines.inject(0) { |sum, line| sum + line.illegal_close_score }
  end

  def autocomplete_score
    scores = syntax_lines.map(&:autocomplete_score).compact
    scores.sort!

    scores[scores.length / 2]
  end

  private

  attr_reader :syntax_lines
end

class SyntaxLine
  def initialize(line:)
    @line = line
    @close_count = 0
    @illegal_close_score = 0
    @valid = true
    @finished = false
    @open_stack = []

    process
  end

  def chunks
    return nil unless success?

    @close_count
  end

  def illegal_close_score
    return 0 if valid?

    @illegal_close_score
  end

  def autocomplete_score
    return nil unless valid?

    autocomplete_chars.inject(0) { |sum, char| (sum * 5) + (autocomplete_char_score char: char) }
  end

  def success?
    valid? && complete? && finished?
  end

  def valid?
    @valid
  end

  def complete?
    open_stack.length.zero?
  end

  def finished?
    finished
  end

  private

  attr_reader :line, :close_count, :open_stack, :finished

  OPENING_CHARS = ['[', '{', '(', '<'].freeze
  CLOSING_CHARS = [']', '}', ')', '>'].freeze

  def process
    line.chars.each do |char|
      break unless @valid

      process_char char: char
    end

    @finished = true
  end

  def process_char(char:)
    if OPENING_CHARS.include? char
      open_stack << char
    else
      closing_char_index = OPENING_CHARS.index(open_stack.last)
      expected_closing_char = CLOSING_CHARS[closing_char_index]

      if char != expected_closing_char
        @valid = false
        @illegal_close_score += char_score char: char
        return
      end

      open_stack.pop
      @close_count += 1
    end
  end

  def char_score(char:)
    case char
    when ')'
      3
    when ']'
      57
    when '}'
      1197
    when '>'
      25_137
    else
      0
    end
  end

  def autocomplete_chars
    chars = []
    open_stack.reverse.each do |o|
      closing_char_index = OPENING_CHARS.index(o)
      chars << CLOSING_CHARS[closing_char_index]
    end

    chars
  end

  def autocomplete_char_score(char:)
    case char
    when ')'
      1
    when ']'
      2
    when '}'
      3
    when '>'
      4
    else
      0
    end
  end
end
