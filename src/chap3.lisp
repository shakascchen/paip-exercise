(in-package :cl-user)

(defpackage paip-exercise-chap3
  (:use :cl)
  (:export #:dotted-expression
           #:print-expression
           #:length-reduce))
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

;;; 3.4
(defun print-expression (form &key dotted-expression-p)
  (if dotted-expression-p
      (dotted-expression form)
      (print form)))

;;; 3.6
'(local-a local-b local-b global-a global-b)

;;; 3.7
;; A: the first found in the list

;;; 3.8


;;; 3.9
(defun length-reduce (list)
  (reduce '+
          (mapcar (lambda (elt) 1)
                  list)))


