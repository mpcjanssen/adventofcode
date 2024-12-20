module AOC
  def self.all_ints(input)
    input.scan(/-?\d+/).map(&:to_i)
  end

  class Cgrid
    DIR4 = [1,-1,Complex::I,-Complex::I]
    include Enumerable
    attr_accessor :rows, :cols, :default,:grid
    def initialize(input, default="#")
      @rows = 0
      @cols = 0
      @grid = {}
      @grid.default = default
      input.lines.each.with_index { |l,ridx|
        @rows+=1
        @cols = 0
        l.strip.chars.each.with_index { |v,cidx|
          @cols+=1
          @grid[Complex(cidx,ridx)] = v
        }
      }
    end
    def []=(idx,val)
      @grid[idx] = val
    end
    def [](idx)
      @grid[idx]
    end
    def each(&block)
      @grid.each { |it| block.call(it)}
    end
    def display()
      (0...@rows).map.with_index { |ridx|
        (0...@cols).map.with_index { |cidx|
          @grid[Complex(cidx,ridx)]
        }.join("")
      }.join("\n")
    end

    def find_one(val)
      @grid.find {|_,v| v == val }.first
    end
    def find_all(val)
      if val.is_a? Enumerable
        @grid.filter {|_,v| val.include? v }.keys
      else
        @grid.filter {|_,v| val == v }.keys  
      end
    end

    def manh(c1,c2)
      (c1.real - c2.real).abs + (c1.imag - c2.imag).abs
    end
    def dir4
      DIR4
    end
  end
end