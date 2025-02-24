(def input
  (->>
   (slurp "in.txt")
   (map #(if (= % \() 1 -1))))

(let
    [reds (reductions + input)
     part1 (last reds)
     part2 (.indexOf reds -1)]
  (println part1 part2))
