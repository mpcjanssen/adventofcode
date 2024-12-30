# frozen_string_literal: true

##
# Helper module for AOC
module AOC
  def self.all_ints(input)
    input.scan(/-?\d+/).map(&:to_i)
  end

  # A grid of complex numbers with a configurable default value
  # for points outside of the grid (default value #)
  class Cgrid
    DIR4 = [1, -1, Complex::I, -Complex::I].freeze
    include Enumerable
    attr_accessor :rows, :cols, :default, :grid

    def initialize(input, default = '#')
      @rows = 0
      @cols = 0
      @grid = {}
      @grid.default = default
      input.lines.each.with_index do |l, ridx|
        @rows += 1
        @cols = 0
        l.strip.chars.each.with_index do |v, cidx|
          @cols += 1
          @grid[Complex(cidx, ridx)] = v
        end
      end
    end

    def []=(idx, val)
      @grid[idx] = val
    end

    def [](idx)
      @grid[idx]
    end

    def each(&block)
      @grid.each { |it| block.call(it) }
    end

    def display
      (0...@rows).map do |ridx|
        (0...@cols).map do |cidx|
          @grid[Complex(cidx, ridx)]
        end.join('')
      end.join("\n")
    end

    def find_one(val)
      @grid.find { |_, v| v == val }.first
    end

    def find_all(val)
      if val.is_a? Enumerable
        @grid.filter { |_, v| val.include? v }.keys
      else
        @grid.filter { |_, v| val == v }.keys
      end
    end

    def manh(cp1, cp2)
      (cp1.real - cp2.real).abs + (cp1.imag - cp2.imag).abs
    end

    def dir4
      DIR4
    end
  end
end
