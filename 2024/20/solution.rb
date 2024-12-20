    require_relative '../../lib/aoc.rb'
    input = $stdin.read()

    grid = AOC::Cgrid.new(input)
    puts grid.display
    
    start = grid.find_one 'S' 
    target = grid.find_one 'E' 
    
    cache = {}
    def solve(grid,start,target)
      dirs = grid.dir4
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
    
    def cheats(grid,start, target, cheattime)
      imps = {}
      imps.default = 0
      scores = solve(grid,start,target)
      cleanscore = scores[target]
      racetrack = grid.find_all "SE.".chars
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
          dist = grid.manh(p1,p2) 
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
    
    p [cheats(grid,start,target,2).filter {|k,_| k >= 100}.values.sum,
    cheats(grid,start,target,20).filter {|k,_| k >= 100}.values.sum]