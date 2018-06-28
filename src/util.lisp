(in-package :cl-user)
(defpackage paip-exercise-util
  (:use :cl)
  (:export #:redefun
           #:restore-fun))
(in-package :paip-exercise-util)

(defmacro redefun (function &rest body)
  `(progn
     (anaphora:sunless (get ',function :origin)
       (setf anaphora:it
             (symbol-function ',function)))
     (defun ,function ()
       ,@body)))

(defun restore-fun (function-symbol)
  (setf (symbol-function function-symbol) (get function-symbol :origin)))

