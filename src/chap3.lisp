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

;; defined for exercise 3.4
(defmacro print-when-print-parenthesis-p (character)
  `(when print-parenthesis-p
     (princ ,character)))

(defun dotted-expression (form &key (print-parenthesis-p t))
  (if (atom form)
      (princ form)
      (progn
        (print-when-print-parenthesis-p #\()
        (dotted-expression (car form))
        (princ " . ")
        (dotted-expression (cdr form))
        (print-when-print-parenthesis-p #\))
        form)))

;;; 3.4
(defun print-expression (form &rest rest &key (print-parenthesis-p t))
  (cond ((null form))
        ((and (consp form)
              (listp (cdr form)))
         (print-when-print-parenthesis-p #\()
         (print-expression (car form))
         (when (cdr form)
           (princ #\Space))
         (print-expression (cdr form)
                           :print-parenthesis-p nil)
         (print-when-print-parenthesis-p #\))
         form)
        (t (apply 'dotted-expression
                  (cons form
                        rest)))))

;;; 3.5


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


