(def input
  (->>
   (slurp "in.txt")
   (re-seq #"-?\d+")
   (map #(Integer/parseInt %))
   (partition 3)))

(defn wrap1 [dims]
  (let [[x y z] (sort dims)]
    (+ (* x y 2) (* x z 2) (* z y 2) (* x y))))

(defn wrap2 [dims]
  (let [[x y z] (sort dims)]
    (+ x x y y (* x y z))))


(println
 (apply + (map wrap1 input))
 (apply + (map wrap2 input)))
        

