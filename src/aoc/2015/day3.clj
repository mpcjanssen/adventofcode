(ns aoc.2015.day3
  (:require [clojure.string :as str]
            [aoc.core :as aoc]))

(def input 
  (slurp "./2015/input/3.txt"))

(defn move [[x y] dir]
  (case dir
    \^ [x (- y 1)]
    \< [(- x 1) y]
    \> [(+ x 1) y]
    \v [x (+ y 1)]))


(def eggnog
 (aoc/transpose 
  (partition 2 input)))

(count  
 (set
  (concat
   (reductions move [0 0] (first eggnog))
   (reductions move [0 0] (last eggnog)))))


(defn solve []
   [(count (set (reductions move [0 0] input)))
    (count
     (set
      (concat
       (reductions move [0 0] (first eggnog))
       (reductions move [0 0] (last eggnog)))))])  
  