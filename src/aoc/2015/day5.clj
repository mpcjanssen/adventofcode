(ns aoc.2015.day5
  (:require [aoc.core :as aoc]
            [clj-commons.digest :as digest]
            [clojure.string :as str]))

(def input 
   (slurp "./2015/input/5.txt"))

(def strings  (str/split-lines input))


(defn prop1 [string]
  (> 
   (count (re-seq #"[aieou]" string))
   2))

(defn prop2 [string]
  (re-find #"(.)\1" string))

(defn prop3 [string]
  (not (re-find #"(ab|cd|pq|xy)" string)))


(defn nice1 [string]
  (and
   (prop1 string)
   (prop2 string)
   (prop3 string)))

(defn nice2 [string]
  (and
   (re-find #"(..).*\1" string)
   (re-find #"(.).\1" string)))

(defn solve []
  [(count (filter identity (map nice1 strings)))
   (count (filter identity (map nice2 strings)))])