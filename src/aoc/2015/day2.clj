(ns aoc.2015.day2
  (:require [clojure.string :as str]
            [aoc.core :as aoc]))

(def input 
  (slurp "./2015/input/2.txt"))

(defn box [l]
  ;; sort the sides of the boxes so [x y z]  gives x and y
  ;; for the shortest sides
  (sort (map #(Integer/parseInt % ) (str/split l #"x")))) 
   

(def boxes
  (map box (str/split-lines input)))

(defn wrapping [box]
  (let 
   [[x y z] box] 
   (+ 
    (* 2 x y) 
    (* 2 y z) 
    (* 2 z x)
    (* x y))))

(defn ribbon [box]
  (let
   [[x y z] box] 
   (+
    (+ x y x y)
    (* x y z))))


(defn solve []
    [(aoc/mapsum wrapping boxes)
     (aoc/mapsum ribbon boxes)])  
