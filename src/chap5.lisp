(in-package :cl-user)

(defpackage paip-exercise-chap5
  (:use :cl :paip-exercise-eliza-basic)
  (:export #:eliza-5.6))

(in-package :paip-exercise-chap5)

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

