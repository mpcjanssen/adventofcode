(ns aoc.2015.core
  (:require [clojure.pprint :as pprint]))

(gen-class)
(require 'aoc.2015.day1)
(require 'aoc.2015.day2)
(require 'aoc.2015.day3)

(defn -main
  [& _]
  (pprint/pprint (aoc.2015.day1/solve)) 
  (pprint/pprint (aoc.2015.day2/solve)) 
  (pprint/pprint (aoc.2015.day3/solve)))              
