(in-package :cl-user)

(defpackage paip-exercise-chap3
  (:use :cl)
  (:export #:dotted-expression
           #:print-expression
           #:length-reduce
           #:length-reduce-by-key
           #:find-all
           #:sentence))
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
'(local-a local-b local-b global-a local-b) ; notice the different between dynamical variable, lexical variable, and global variable!!

;;; 3.7
;; A: the first found in the list

;;; 3.8
(defun find-all (item sequence &rest keyword-args
                 &key (test #'eql) test-not &allow-other-keys)
  "Find all those elements of sequence that match item,
  according to the keywords.  Doesn't alter sequence."
  (setf test
        (or (getf :test keyword-args)
            test))
  (setf test-not
        (or (getf :test-not keyword-args)
            test-not))
  (if test-not
      (apply #'remove item sequence 
             :test-not (complement test-not) keyword-args)
      (apply #'remove item sequence
             :test (complement test) keyword-args)))

;;; 3.9
(defun length-reduce (list)
  (reduce '+
          (mapcar (lambda (elt) 1)
                  list)))

(defun length-reduce-by-key (list)
  (reduce '+
          list
          :key (lambda (x) 1)))

;;; 3.10
(describe 'cl:lcm)
;; COMMON-LISP:LCM
;;   [symbol]

;; LCM names a compiled function:
;;   Lambda-list: (&REST INTEGERS)
;;   Declared type: (FUNCTION (&REST INTEGER)
;;                   (VALUES UNSIGNED-BYTE &OPTIONAL))
;;   Derived type: (FUNCTION (&REST T) (VALUES INTEGER &OPTIONAL))
;;   Documentation:
;;     Return the least common multiple of one or more integers. LCM of no
;;       arguments is defined to be 1.
;;   Known attributes: foldable, flushable, unsafely-flushable, movable
;;   Source file: SYS:SRC;CODE;NUMBERS.LISP

(describe 'cl:nreconc)
;; COMMON-LISP:NRECONC
;;   [symbol]

;; NRECONC names a compiled function:
;;   Lambda-list: (X Y)
;;   Declared type: (FUNCTION (LIST T) (VALUES T &OPTIONAL))
;;   Documentation:
;;     Return (NCONC (NREVERSE X) Y).
;;   Known attributes: important-result
;;   Source file: SYS:SRC;CODE;LIST.LISP

(describe 'cl:nreverse)
;; COMMON-LISP:NREVERSE
;;   [symbol]

;; NREVERSE names a compiled function:
;;   Lambda-list: (SEQUENCE)
;;   Declared type: (FUNCTION (SEQUENCE) (VALUES SEQUENCE &OPTIONAL))
;;   Derived type: (FUNCTION (T) (VALUES SEQUENCE &OPTIONAL))
;;   Documentation:
;;     Return a sequence of the same elements in reverse order; the argument
;;        is destroyed.
;;   Known attributes: important-result
;;   Source file: SYS:SRC;CODE;SEQ.LISP

(describe 'cl:nconc)
;; COMMON-LISP:NCONC
;;   [symbol]

;; NCONC names a compiled function:
;;   Lambda-list: (&REST LISTS)
;;   Declared type: (FUNCTION * (VALUES T &OPTIONAL))
;;   Derived type: (FUNCTION (&REST T) (VALUES T &OPTIONAL))
;;   Documentation:
;;     Concatenates the lists given as arguments (by changing them)
;;   Source file: SYS:SRC;CODE;LIST.LISP


;;; 3.11
(describe 'acons)
;; COMMON-LISP:ACONS
;;   [symbol]

;; ACONS names a compiled function:
;;   Lambda-list: (KEY DATUM ALIST)
;;   Declared type: (FUNCTION (T T T) (VALUES CONS &OPTIONAL))
;;   Documentation:
;;     Construct a new alist by adding the pair (KEY . DATUM) to ALIST.
;;   Inline proclamation: MAYBE-INLINE (inline expansion available)
;;   Known attributes: flushable, unsafely-flushable, movable
;;   Source file: SYS:SRC;CODE;LIST.LISP

;;; 3.12
(defun sentence (word-list)
  (format t
          "~@(~{~a~^ ~}~)."
          word-list))

