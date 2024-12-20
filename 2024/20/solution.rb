    grid = {}
    grid.default = '#'
    data = $stdin.readlines.each.with_index { |l,ridx|
      l.strip.chars.each.with_index { |v,cidx|
        grid[Complex(cidx,ridx)] = v
      }
    }
    
    start = grid.find {|_,v| v == 'S' }.first
    target = grid.find  {|_,v| v == 'E' }.first
    
    cache = {}
    def solve(grid,start,target)
      dirs = [1,-1,Complex::I,-Complex::I]
      scores = {start => 0}
      heads = Queue.new
      heads.push start
      while scores[target].nil? && heads.size > 0
        head = heads.pop
        score = scores[head]
        dirs.each { |dir|
          nexthead = head + dir 
          next if grid[nexthead] == nil
          next if grid[nexthead] == '#'
          next if scores[nexthead] != nil
          heads.push nexthead
          scores[nexthead] = score+1
        }
      end
      return scores
    end
    
    def manh(c1,c2)
      m = (c1.real - c2.real).abs + (c1.imag - c2.imag).abs
      # p [c1,c2, m]
      m
    end
    
    def cheats(grid,start, target, cheattime)
      imps = {}
      imps.default = 0
      scores = solve(grid,start,target)
      cleanscore = scores[target]
      racetrack = grid.filter {|_,v| ['S', '.', 'E'].include?(v) }.map{|k,_| k}
      racetrack = racetrack.sort_by {|p| scores[p]}

      # verify that the racetrack has no dead ends or wider parts
      # so that every point has a proper score when solving with BFS once
      raise "Racetrack assumption not correct" if cleanscore != racetrack.size-1
    
      (0..racetrack.size-1).each {| idx |
        p1 = racetrack[idx]

        # Only consider points later on the racetrack as cheat target
        options = racetrack[idx+1..-1]
        # p options.size
        
        diststart = scores[p1]
        options.each { |p2|
          dist = manh(p1,p2) 
          next if dist > cheattime
          distend = cleanscore - scores[p2]
          newdist = diststart+distend+dist
          delta = cleanscore - newdist
          imps[delta]+=1 if delta > 0
        }    
      }
      return imps
    end
    
    # p cheats(grid,start,target,2)
    # p cheats(grid,start,target,20).filter {|k,v| k >= 50}
    
    p [cheats(grid,start,target,2).filter {|k,v| k >= 100}.map {|_,v| v}.sum,
    cheats(grid,start,target,20).filter {|k,v| k >= 100}.map {|_,v| v}.sum]