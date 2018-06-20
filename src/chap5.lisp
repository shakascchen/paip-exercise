(in-package :cl-user)

(defpackage paip-exercise-chap5
  (:use :cl :paip-exercise-eliza-basic)
  (:export #:eliza
           #:do-5.6
           #:undo-5.6
           #:clear-eliza-memory
           #:do-5.7
           #:undo-5.7
           #:do-5.11
           #:undo-5.11))

(in-package :paip-exercise-chap5)

(defvar *segment-match* (symbol-function 'segment-match))

(defvar *pat-match* (symbol-function 'pat-match))

(defvar *match-variable* (symbol-function 'match-variable))

(defvar *extend-bindings* (symbol-function 'extend-bindings))

(defvar *use-eliza-rules* (symbol-function 'use-eliza-rules))

(defvar *eliza-basic* (symbol-function 'eliza))

;;; 5.1
;; no, recall the reason! The answer is in the book.

;;; 5.2

;; ELIZA> hi
;; DO YOU FEEL STRONGLY ABOUT DISCUSSING SUCH THINGS?
;; ELIZA> It was just a greeting.
;; I AM NOT SURE I UNDERSTAND YOU FULLY
;; ELIZA> just say hi back. Can't you do that?
;; WHAT DOES THAT SUGGEST TO YOU?
;; ELIZA> It means you know poLiteness in some sense.
;; PLEASE CONTINUE
;; ELIZA> TeLL me something interesting.
;; PLEASE CONTINUE
;; ELIZA> I want you be the side who continues.
;; WHY DO YOU WANT I BE THE SIDE WHO CONTINUES?
;; ELIZA> It's tiring to generate topics.
;; GO ON
;; ELIZA> Then don't teLL me to go on.
;; WHAT DOES THAT SUGGEST TO YOU?
;; ELIZA> It means you intentionaLLy make me more tired.
;; VERY INTERESTING
;; ELIZA> not at all. I feel angry on you.
;; DO YOU OFTEN FEEL ANGRY ON I?


;; performing ok:
;; 1. "What does that suggest to you?" plays a good trick....
;; 1.1
;; ELIZA> just say hi back. Can't you do that?
;; WHAT DOES THAT SUGGEST TO YOU?
;; 1.2
;; ELIZA> Then don't teLL me to go on.
;; WHAT DOES THAT SUGGEST TO YOU?
;; ELIZA> It means you intentionaLLy make me more tired.
;; VERY INTERESTING -> this is bad but can make sense according to context......

;; 2. Why is a good trick for replying to "want"
;; ELIZA> I want you be the side who continues.
;; WHY DO YOU WANT I BE THE SIDE WHO CONTINUES?

;; problems:
;; 1. It doesn't recognize 'hi' to be greetings.  => change rules
;; 2. Humans can't bear the passive talking style. => at least some rules to mimic activeness.
;; 3. no empathy at all. => eliza. Context sensitive is important.
;;
;; ELIZA> i am angry on you
;; DO YOU WANT TO BE ANGRY ON I ? 
;; ELIZA> It doesn't matter. I'm just angry.
;; DO YOU FEEL STRONGLY ABOUT DISCUSSING SUCH THINGS?
;;
;; ELIZA> I want you be the side who continues.
;; WHY DO YOU WANT I BE THE SIDE WHO CONTINUES?
;; ELIZA> It's tiring to generate topics.
;; GO ON
;; 4. reverse of the subject should consider object form => switch-viewpoint in elize
;; ELIZA> i am angry on you
;; DO YOU WANT TO BE ANGRY ON I ? => angry on me
;;
;; 5. It seems like a machine to give unchange consecutive responses. => eliza. It requires some context sensitive.
;; ELIZA> It means you know poLiteness in some sense.
;; PLEASE CONTINUE
;; ELIZA> TeLL me something interesting.
;; PLEASE CONTINUE

;; 6. no typo tolerance => modify pat-match to have some fuzzy matching
;; ELIZA> helo there
;; GO ON 
;; ELIZA> 

;;; 5.4
;; because quote is legal for (read) . double quote requires complete pairs of it. comma has to be inside backtick
;; '(a ' c d)
;; (A 'C D)
;; PAIP> ''a
;; 'A
;; PAIP> '''a
;; ''A

;;; 5.6

(defun do-5.6 ()
  (defun eliza ()
    "Respond to user input using pattern matching rules."
    (loop
      (print 'eliza>)
      (format t "~{~a~^ ~}" (flatten (use-eliza-rules (anaphora:aprog1 (read)
                                                        (when (equal anaphora:it
                                                                     '(sayoonara))
                                                          (return-from eliza)))))))))

(defun undo-5.6 ()
  (setf (symbol-function 'eliza) *eliza-basic*))

;;; 5.7

(defvar *eliza-memory* nil)

(defvar *synonym-hash-table* (make-hash-table :test 'equal))

(defun defsynonym (&rest rest)
  (mapc (lambda (synonym)
          (setf (gethash synonym *synonym-hash-table*)
                (first rest)))
        rest))

(defun clear-eliza-memory ()
  (setf *eliza-memory* nil))

(defun expand-eliza-memory (alist)
  (mapc (lambda (cons)
          (anaphora:awhen (cdr cons)
            (pushnew anaphora:it
                     *eliza-memory*
                     :test #'eql)))
        alist))

(defun normalize-synonym (list)
  (let ((new-list (copy-list list)))
    (loop for synonym being the hash-key of *synonym-hash-table*
          do (anaphora:awhen (search synonym new-list :test #'equal)
               (setf new-list
                     (concatenate 'list
                                  (subseq new-list 0 anaphora:it)
                                  (gethash synonym *synonym-hash-table*)
                                  (subseq new-list
                                          (+ anaphora:it (length synonym)))))))
    new-list))
  
(defun do-5.7 ()
  (values 
   (mapc (lambda (synonyms)
           (apply 'defsynonym synonyms))
         '(((everyone) (everybody))
           ((family) (father) (mother))
           ((hope) (wish))
           ((how are you doing.) (how do you do.))
           ((don't) (do not))))

   (let ((eliza-rules (mapcar (lambda (rule)
                                (mapcar 'normalize-synonym
                                        rule))
                              *eliza-rules*)))
     (defun use-eliza-rules (input)
       "Find some rule with which to transform the input."
       (some #'(lambda (rule)
                 (let ((result (expand-eliza-memory (pat-match (rule-pattern rule) input))))
                   (if (not (eq result fail))
                       (sublis (switch-viewpoint result)
                               (random-elt (rule-responses rule))))))
             eliza-rules)))
   
   (defun eliza ()
     "Respond to user input using pattern matching rules."
     (loop
       (print 'eliza>)
       (format t "~{~a~^ ~}" (flatten (or (use-eliza-rules (anaphora:aprog1 (normalize-synonym (read))
                                                             (when (equal anaphora:it
                                                                          '(sayoonara))
                                                               (return-from eliza))))
                                          (when *eliza-memory*
                                            `(Tell me more about ,(random-elt *eliza-memory*))))))))))

(defun undo-5.7 ()
  (values (setf (symbol-function 'use-eliza-rules)
                *use-eliza-rules*)
          (setf (symbol-function 'eliza)
                *eliza-basic*)
          (clrhash *synonym-hash-table*)))
  
;;; 5.10
;; it's tricky! think again!

;;; 5.11
;; for the advantage see the function extend-bindings and pat-match comments

(defparameter *no-bindings-as-nil* nil)

(defun do-5.11 ()
  (values
   (defun extend-bindings (var val bindings)
     "Add a (var . value) pair to a binding list."
     (cons (cons var val)
           ;; here becomes so simple in 5.11
           bindings))
   
   (defun match-variable (var input bindings)
     "Does VAR match input?  Uses (or updates) and returns bindings."
     (let ((binding (get-binding var bindings)))
       (cond ((not binding) (extend-bindings var input bindings))
             ((equal input (binding-val binding)) bindings)
             (t :fail))))
   
   (defun pat-match (pattern input &optional bindings) ; and bindings here is already default to nil
     "Match pattern against input in the context of the bindings"
     (cond ((eq bindings :fail) :fail)
           ((variable-p pattern)
            (match-variable pattern input bindings))
           ((eql pattern input) bindings)
           ((segment-pattern-p pattern)                
            (segment-match pattern input bindings))    
           ((and (consp pattern) (consp input)) 
            (pat-match (rest pattern) (rest input)
                       (pat-match (first pattern) (first input) 
                                  bindings)))
           (t :fail)))
   
   (defun segment-match (pattern input bindings &optional (start 0))
     "Match the segment pattern ((?* var) . pat) against input."
     (let ((var (second (first pattern)))
           (pat (rest pattern)))
       (if (null pat)
           (match-variable var input bindings)
           ;; We assume that pat starts with a constant
           ;; In other words, a pattern can't have 2 consecutive vars
           (let ((pos (position (first pat) input
                                :start start :test #'equal)))
             (if (null pos)
                 :fail
                 (let ((b2 (pat-match
                            pat (subseq input pos)
                            (match-variable var (subseq input 0 pos)
                                            bindings))))
                   ;; If this match failed, try another longer one
                   (if (eq b2 :fail)
                       (segment-match pattern input bindings (+ pos 1))
                       b2)))))))

   (defun use-eliza-rules (input)
     "Find some rule with which to transform the input."
     (some #'(lambda (rule)
               (let ((result (pat-match (rule-pattern rule) input)))
                 (if (not (eq result :fail))
                     (sublis (switch-viewpoint result)
                             (random-elt (rule-responses rule))))))
           *eliza-rules*))))

(defun undo-5.11 ()
  (values (setf (symbol-function 'segment-match) *segment-match*)
          (setf (symbol-function 'pat-match) *pat-match*)
          (setf (symbol-function 'match-variable) *match-variable*)
          (setf (symbol-function 'extend-bindings) *extend-bindings*)
          (setf (symbol-function 'use-eliza-rules) *use-eliza-rules*)))
  

;;; 5.12

(defun do-5.12 ()
  (values
   (defun extend-bindings (var val bindings)
     "Add a (var . value) pair to a binding list."
     (cons (cons var val)
           ;; here becomes so simple in 5.11
           bindings))
   
   (defun match-variable (var input bindings)
     "Does VAR match input?  Uses (or updates) and returns bindings."
     ;; default nil means fail
     (let ((binding (get-binding var bindings)))
       (cond ((not binding)
              (values t (extend-bindings var input bindings)))
             ((equal input (binding-val binding))
              (values t bindings)))))
   
   (defun pat-match (pattern input &optional (not-failed-yet t) bindings)
     "Match pattern against input in the context of the bindings"
     ;; default value of cond is nil - means fail
     (cond ((null not-failed-yet) fail)
           ((variable-p pattern)
            (match-variable pattern input bindings))
           ((eql pattern input) (values t bindings))
           ((segment-pattern-p pattern)                
            (segment-match pattern input bindings))    
           ((and (consp pattern) (consp input)) 
            (multiple-value-call 'pat-match
              (rest pattern)
              (rest input)
              (pat-match (first pattern) (first input) t bindings)))))

   (defun segment-match (pattern input bindings &optional (start 0))
     "Match the segment pattern ((?* var) . pat) against input."
     (let ((var (second (first pattern)))
           (pat (rest pattern)))
       (if (null pat)
           (match-variable var input bindings)
           ;; We assume that pat starts with a constant
           ;; In other words, a pattern can't have 2 consecutive vars
           (let ((pos (position (first pat) input
                                :start start :test #'equal)))
             (if (null pos)
                 fail
                 (multiple-value-bind (match-p b2)
                     (multiple-value-call 'pat-match
                       pat
                       (subseq input pos)
                       (match-variable var
                                       (subseq input 0 pos)
                                       bindings))
                   ;; If this match failed, try another longer one
                   (if match-p
                       (values t b2)
                       (segment-match pattern input bindings (+ pos 1)))))))))

   (defun use-eliza-rules (input)
     "Find some rule with which to transform the input."
     (some #'(lambda (rule)
               (multiple-value-bind (match-p result)
                   (pat-match (rule-pattern rule) input)
                 (when match-p
                   (sublis (switch-viewpoint result)
                           (random-elt (rule-responses rule))))))
           *eliza-rules*))))

(defun undo-5.12 ()
  (values (setf (symbol-function 'segment-match) *segment-match*)
          (setf (symbol-function 'pat-match) *pat-match*)
          (setf (symbol-function 'match-variable) *match-variable*)
          (setf (symbol-function 'extend-bindings) *extend-bindings*)
          (setf (symbol-function 'use-eliza-rules) *use-eliza-rules*)))
