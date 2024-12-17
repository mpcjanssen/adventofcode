class Machine
  attr_accessor :ip, :prog, :ra , :rb, :rc, :output
  def initialize(prog)
    @prog = prog
  end

  def combo(opr)
    return case opr
    when 0..3
      opr
    when 4
      @ra
    when 5
      @rb
    when 6
      @rc
    else
      raise "Unknown combo operator #{opr}"
    end
  end

  def targetrun(ra,rb,rc)
    seencache = {}
    orig_ra = ra
    target = prog.clone
    @ra = ra
    @rb = rb
    @rc = rc
    @ip = 0
    loop do
      cached = seencache[[@ra,@rb,@rc,@ip,target]]
      if cached != nil
        return cached
      end
      # p target
      opc = @prog[@ip]
      break if opc.nil?
      opr = @prog[@ip+1]
      case opc
        when 0
          @ra = @ra >> combo(opr)
        when 1
          @rb = @rb ^ opr
        when 2
          @rb = combo(opr)%8
        when 3
          if @ra != 0
            @ip = opr
            next
          end
        when 4
          @rb = @rc ^ @rb
        when 5
          # p "output"
          next_digit = target.shift
          out_digit = combo(opr)%8
          # p [out_digit, next_digit, target]
          if next_digit != out_digit or next_digit == nil
            # p "here"
            return nil
          end
        when 6
          @rb = @ra >> combo(opr)
        when 7
          @rc = @ra >> combo(opr)
        else
          raise "Unknown opcode #{opc}"
      end
      @ip+=2
    end
    if target == []
      return orig_ra
    else
      nil
    end
  end


  def run(ra,rb,rc)
    @ra = ra
    @rb = rb
    @rc = rc
    @ip = 0
    @output = []

    loop do
      opc = @prog[@ip]
      break if opc.nil?
      opr = @prog[@ip+1]
      case opc
        when 0
          @ra = @ra/(2.pow(combo(opr))).truncate()
        when 1
          @rb = @rb ^ opr
        when 2
          @rb = combo(opr)%8
        when 3
          if @ra != 0
            @ip = opr
            next
          end
        when 4
          @rb = @rc ^ @rb
        when 5
          @output << combo(opr)%8
        when 6
          @rb = @ra/(2.pow(combo(opr))).truncate()
        when 7
          @rc = @ra/(2.pow(combo(opr))).truncate()
        else
          raise "Unknown opcode #{opc}"
      end
      @ip+=2
    end
    @output
  end
end

input = $stdin.read()
ra,rb,rc,*prog =  input.scan(/-?\d+/).map(&:to_i)

m = Machine.new(prog)
puts m.run(ra,rb,rc).join(',')

(1..).each { |ra|
  res = m.targetrun(ra,rb,rc)
  p ra if ra % 10000 == 0
  if res != nil
    p [res, ra]
    break
  end
}
