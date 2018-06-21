
;;; the easiest way of reuse
(uiop:define-package paip2
    (:use :cl :paip)
  (:reexport :paip))


;;; graceful reuse, shown by snmsts
(defvar *apply-result-pat-match* #'identity)


;; this code come from blah blah and some modification. see (https://github....)
(defun use-eliza-rules (input &key (*apply-result-pat-match* *apply-result-pat-match*))
  "Find some rule with which to transform the input."
  (some #'(lambda (rule)
            (let ((result (funcall *apply-result-pat-match* (pat-match (rule-pattern rule) input))))
              (if (not (eq result fail))
                  (sublis (switch-viewpoint result)
                          (random-elt (rule-responses rule))))))
        eliza-rules))

(defun use-eliza-rules2 (&rest args)
  (let ((*apply-result-pat-match* 'expand-eliza-memory))
    (apply 'use-eliza-rules args)))



;;; shaka's wish but the situation rarely happens, so forget about it.
(redefun use-eliza-rules)
;; execute =>
;; code appears here (virtually)
(defun use-eliza-rules (input &key (*apply-result-pat-match* *apply-result-pat-match*))
  "Find some rule with which to transform the input."
  (some #'(lambda (rule)
            (let ((result (funcall *apply-result-pat-match* (pat-match (rule-pattern rule) input))))
              (if (not (eq result fail))
                  (sublis (switch-viewpoint result)
                          (random-elt (rule-responses rule))))))
        eliza-rules))

;; and I modify the code virtually

;; finally the code is generated (maybe when compiling)


;;; code for redefun a function and restore the function by snmsts
(defmacro redefun (function &body)
  `(progn
     (setf (get ,function :origin) (symbol-function
                                    ,function))
     (defun ,funciton ,@body)))

(defun restorefun (function)
  (setf (symbol-function function) (get function :origin)))
