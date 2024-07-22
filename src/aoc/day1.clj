(ns aoc.day1
  (:require [clojure.pprint :as pprint]))

(defonce input
 (slurp "./2015/input/1.txt"))


(defn delta [c]
  (case c
   \( 1
    \) -1))

(defonce deltas
  (map delta input))
  

(defn part1 []
 (apply + deltas))

(defn part2 []
 (count
  (reductions
   #(if (= %1 -1) (reduced nil) (+ %1 %2))
    deltas)))

(defn solve []
  [(part1) (part2)])
