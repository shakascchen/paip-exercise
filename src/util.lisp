(in-package :cl-user)
(defpackage paip-exercise-util
  (:use :cl)
  (:export #:redefun
           #:restore-fun))
(in-package :paip-exercise-util)

(defmacro redefun (name &rest body)
  `(progn
     (anaphora:sunless (get ',name :origin)
       (setf anaphora:it
             (symbol-function ',name)))
     (defun ,name ()
       ,@body)))

(defun restore-fun (symbol)
  (setf (symbol-function symbol) (get symbol :origin)))

