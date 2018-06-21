(in-package :cl-user)

(defpackage paip-exercise-chap6
  (:use :cl))
(in-package :paip-exercise-chap6)

;;; Question
;; pros and cons of using 'get' should be free of declaration, isn't it?

;;; note PAIP page 183
;; a function that looks up a data-driven function and calls it is called a "dispatch function"

;;; note PAIP page 189
;; Search problems are called nondeterministic because there is no way to determine what is the best step to take next. AI problems, by their very nature, tend to be nondeterministic.

;;; recall dfs, bfs, best-first search, beam search, depth-only search (hill-climbing p. 197)

;;; note PAIP page 197
;; we can find a goal either by looking at more states, or by being smarter about the states we look at. That means having a better ordering function
