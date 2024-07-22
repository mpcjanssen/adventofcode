(ns aoc.day2
  (:require [clojure.string :as str]))

(defonce input
 (slurp "./2015/input/2.txt"))

(defn box [l]
  (map #(Integer/parseInt %) (str/split l #"x"))) 
   

(box "1x2x3")

(def boxes
  (map box (str/split-lines input)))

boxes