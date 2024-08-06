(ns aoc.2015.day4
  (:require [aoc.core :as aoc]
            [clj-commons.digest :as digest]
            [clojure.string :as str]))

(def input 
   (slurp "./2015/input/4.txt"))

(def secret (str/trim input))

(def tries
 (map-indexed #(vector %1 (digest/md5 (str secret %2))) (drop 1 (range))))

(defn first-prefix [prefix qs]
 (first 
  (first
  (filter 
   #(str/starts-with? (last %) prefix)
   qs))))

(defn solve []
  [(first-prefix "00000" tries)
   (first-prefix "000000" tries)])