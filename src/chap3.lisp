(in-package :cl-user)

(defpackage paip-exercise-chap3
  (:use :cl)
  (:export #:dotted-expression
           #:print-expression
           #:length-reduce
           #:find-all))
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
(defun find-all (item sequence &rest keyword-args
                 &key (test #'eql) test-not &allow-other-keys)
  "Find all those elements of sequence that match item,
  according to the keywords.  Doesn't alter sequence."
  (macrolet ((set-key-f (key-symbol)
               `(let ((key-symbol-keyword ,(intern (symbol-name key-symbol)
                                                   :keyword)))
                  (anaphora:awhen (position ,(intern (symbol-name key-symbol)
                                                     :keyword)
                                            keyword-args
                                            :from-end t)
                    (setf ,key-symbol
                          (getf (subseq keyword-args
                                        anaphora:it)
                                key-symbol-keyword))))))
    (set-key-f test)
    (set-key-f test-not))
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


