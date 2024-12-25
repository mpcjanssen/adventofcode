items = $stdin.read.strip.split("\n\n").map {|it| it.strip.split("\n").map(&:chars)}

$locks =[]
$keys = []

items.each { |it|
  heights = it.transpose.map {|col| col.count("#")-1}
  $locks << heights if it[0][0] == '#'
  $keys << heights if it[0][0] == '.'

}

def fit(key, lock)
   key.zip(lock).each { |kh, lh |
      return false if kh+lh > 5

   }
   return true
end

part1 = $keys.map {|k|
  $locks.map{|l|
    fit(k,l)
  }
}.flatten(1).count(true)

p part1
