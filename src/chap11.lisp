(in-package :cl-user)

(defpackage paip-exercise-chap11
  (:use :cl))
(in-package :paip-exercise-chap11)

;;; p.348
;; the idea behind logic programming is that the programmer should state the relationships that describe the problem and its solution.
;; These relationships means constraints.(logical specification)
;; The system itself is responsible for the details of the algorithm.

;;; p. 349
;; 3 ideas of prolog

;;; p. 351
;; facts vs. rules
;; interpretation: declarative vs. procedural vs. backward-chaining vs. forward chaining
;; head vs. body

;;; p. 352
;; unification (unify) of logic variables

;;; p. 379
;; Question to make sure :constructor ? ()   for efficient because of?
