(ns aoc.2015.core
  (:require [clojure.pprint :as pprint]))

(gen-class)
(require 'aoc.2015.day1)
(require 'aoc.2015.day2)
(require 'aoc.2015.day3)
(require 'aoc.2015.day4)
(require 'aoc.2015.day5)

(defn -main
  [& _]
  (pprint/pprint {:day1 (aoc.2015.day1/solve)}) 
  (pprint/pprint {:day2 (aoc.2015.day2/solve)}) 
  (pprint/pprint {:day3 (aoc.2015.day3/solve)})
  (pprint/pprint {:day4 (aoc.2015.day4/solve)})
  (pprint/pprint {:day4 (aoc.2015.day5/solve)}))
