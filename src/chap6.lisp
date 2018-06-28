(in-package :cl-user)

(defpackage paip-exercise-chap6
  (:use :cl :paip)
  (:export #:eliza-by-tools))
(in-package :paip-exercise-chap6)

;;; Question
;; pros and cons of using 'get' should be free of declaration, isn't it?

;;; note PAIP page 183
;; a function that looks up a data-driven function and calls it is called a "dispatch function"

;;; note PAIP page 189
;; Search problems are called nondeterministic because there is no way to determine what is the best step to take next. AI problems, by their very nature, tend to be nondeterministic.

;;; recall dfs, bfs, best-first search, beam search, depth-only search (hill-climbing p. 197), A* search (p. 208)

;;; note PAIP page 197
;; we can find a goal either by looking at more states, or by being smarter about the states we look at. That means having a better ordering function

;;; note PAIP page 204
;; non-admissible hueristic search
;; iterative widening vs. iterative deepening

;;; builtin function (merge)

;;; Question: can there be A* beam search?
;; with or without path saving, search algorithm classifications remain?

;;; idea note PAIP page 175
;; Man is a tool-using animal.... Without tools he is nothing. with tools he is all. -Thomas Carlyle (1795-1881)

;;; Question: how to name this?
;; (defmacro redefun (function &rest body)
;;   `(progn
;;      (setf (get ',function :origin)
;;            (symbol-function ',function))
;;      (defun ,function ,@body)))

(defun interactive-interpreter (prompt transformer)
  "Read an expression, transform it, and print the result."
  (loop
    (handler-case
        (progn
          (if (stringp prompt)
              (print prompt)
              (funcall prompt))
          (print (funcall transformer (read))))
      ;; In case of error, do this:
      (error (condition)
        (format t "'^&;; Error ~a ignored, back to top level. " condition)))))

(defun prompt-generator (&optional (num 0) (ctl-string "[~d] "))
  "Return a function that prints prompts like [1]. [2]. etc."
  #'(lambda () (format t ctl-string (incf num))))

(defun eliza-by-tools ()
  (do-examples 6)
  (paip::load-paip-file "patmatch")
  (paip-exercise-util:redefun paip::eliza
                              (interactive-interpreter "eliza-by-tools>"
                                                       #'(lambda (input)
                                                           (if (equal input '(paip::sayoonara))
                                                               (return-from paip::eliza)
                                                               (paip::flatten (paip::use-eliza-rules input)))))))
