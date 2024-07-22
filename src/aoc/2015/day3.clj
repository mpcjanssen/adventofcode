(ns aoc.2015.day3
  (:require [clojure.string :as str]
            [aoc.core :as aoc]))

(defonce input 
  (slurp "./2015/input/3.txt"))

(defn move [[x y] dir]
  (case dir
    \^ [x (- y 1)]
    \< [(- x 1) y]
    \> [(+ x 1) y]
    \v [x (+ y 1)]))



(defn solve []
   [(count (set (reductions move [0 0] input)))])  
  