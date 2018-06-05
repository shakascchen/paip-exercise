(in-package :cl-user)

(defpackage paip-exercise-chap4
  (:use :cl :paip)
  (:export #:permutations))


;; 4.1 
(in-package :paip)
(defun dbg-indent (id indent format-string &rest args)
  "Print indented debugging info if (DEBUG ID) has been specified."
    (format *debug-io*
            "~:[~;~&~V@T~?~]"
            (member id *dbg-ids*)
            (* 2 indent)
            format-string
            args))

(in-package :paip-exercise-chap4)

;; 4.2
(defun %permutations (list)
  (if (cdr list)
      (mapcan (lambda (elt)
                (mapcar (lambda (sub-permutations)
                          (cons elt sub-permutations))
                        (%permutations (remove elt list))))
              list)
      (list list)))

(defun permutations (list)
  (%permutations (remove-duplicates list)))
   

