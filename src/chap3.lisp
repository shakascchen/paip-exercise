(in-package :cl-user)

(defpackage paip-exercise-chap3
  (:use :cl)
  (:export #:dotted-expression))
(in-package :paip-exercise-chap3)

;;; 3.1
((lambda (x)
   ((lambda (y) (+ x y))
    (* x x)))
 6)

;;; 3.2
(cons 'a '(b))
(list* 'a '(b))

;;; 3.3
(defun dotted-expression (form)
  (if (atom form)
      (princ form)
      (progn
        (princ "(")
        (dotted-expression (car form))
        (princ " . ")
        (dotted-expression (cdr form))
        (princ ")"))))
