(ns aoc.core)

(defn mapsum [fn qs]
  (apply
   +
   (map fn qs)))

(defn transpose [m]
  (apply mapv vector m))