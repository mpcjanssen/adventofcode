(ns aoc.core)

(import 'java.security.MessageDigest
        'java.math.BigInteger)

(defn mapsum [fn qs]
  (apply
   +
   (map fn qs)))

(defn transpose [m]
  (apply mapv vector m))

