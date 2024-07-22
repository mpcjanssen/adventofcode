(ns aoc.core)

(defn mapsum [fn qs]
  (apply
   +
   (map fn qs)))