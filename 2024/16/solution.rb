data = $stdin.readlines.map {|l| l.strip.chars }
wy = data.count
wx = data[0].count
cgrid = {}
cgrid.default = '#'

data.each.with_index {|r,ridx|
  r.each.with_index { |v,cidx|
    cgrid[Complex(cidx,ridx)] = v
  }
}

start = cgrid.find do |_,v|
  v == 'S'
end.first

target = cgrid.find do |_,v|
  v == 'E'
end.first

scores = {}
scores.default = nil
dir = 1
scores[[start,dir]] = 0

# 3 options to move straight (1pt) ,  turn left and straight (1001 pt) and right and straight (1001 pt)
# if the visited point was already visited and the score is lower than current we can prune that path


def walk1(cgrid, start, target)
  scores = {}
  scores.default = nil
  heads = [[start,1]]
  scores[heads.first] = 0
  loop do
    active_heads = heads.reject { |pos,dir| pos == target   }
    # p active_heads.count
    return scores if active_heads.count == 0
    newheads = []
    active_heads.each { |pos, dir|
      score = scores[[pos,dir]]
      [[1,1], [Complex::I,1001], [-Complex::I,1001]].each { |move, dscore|
        newdir = move*dir
        newpos = pos + newdir
        # p "move pos #{pos} #{move} -> #{newpos} #{newdir}"
        next if cgrid[newpos] == '#'
        newscore = score + dscore
        if scores[[newpos,newdir]] == nil || scores[[newpos,newdir]] > newscore
          scores[[newpos,newdir]] = newscore
          newheads << [newpos,newdir]
        end
      }

    }
    # p newheads
    heads = newheads
  end
end
scores = walk1(cgrid,start,target)
part1 =  scores.filter {|k,__| pos,dir = k ;  pos == target}.map {|k,v| v}.sort.first




def walk2(cgrid,start, target, maxscore)
  bestpaths = []
  bestscores = {}
  bestscores.default = maxscore+1
  walks = [{path: [start], dir: 1, score: 0 }]
  loop do
    active_walks = walks.reject { |w| w[:path].last == target || w[:score] >= maxscore}
    # p active_walks.count
    return bestpaths if active_walks.count == 0
    newwalks = []
    active_walks.each { |w|
      score = w[:score]
      dir = w[:dir]
      [[1,1], [Complex::I,1001], [-Complex::I,1001]].each { |move, dscore|
        path = w[:path].clone
        pos = path.last
        newdir = move*dir
        newpos = pos + newdir
        # p score if newpos == target
        # p "move pos #{pos} #{move} -> #{newpos} #{newdir}"
        next if cgrid[newpos] == '#'
        newscore = score + dscore
        next if newscore > bestscores[[newpos,newdir]] || newscore > maxscore
        bestscores[[pos,dir]] = newscore
        next if path.include? newpos
        path << newpos
        bestpaths << path   if newpos == target && newscore == maxscore
        newwalk = {path: path, dir:newdir, score: newscore}
        newwalks << newwalk
    }

    }
    # p newheads
    walks = newwalks
  end
end
require 'set'
part2 = walk2(cgrid,start,target,part1).flatten.to_set.count
p [part1,part2]
