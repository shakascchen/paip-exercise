(in-package :cl-user)

(defpackage paip-exercise-chap4
  (:use :cl :paip)
  (:export #:permutations))


;;; 4.1 
(in-package :paip)
(defun dbg-indent (id indent format-string &rest args)
  "Print indented debugging info if (DEBUG ID) has been specified."
  (format *debug-io*
          "~:[~;~&~V@T~?~]"
          (member id *dbg-ids*)
          (* 2 indent)
          format-string
          args))

(in-package :paip-exercise-chap4)

;;; 4.2
(defun permutations (list)
  (if list
      (mapcan (lambda (elt)
                (mapcar (lambda (sub-permutations)
                          (cons elt sub-permutations))
                        (permutations (remove elt list :count 1))))
              list)
      '(())))

;;; 4.3
(in-package :paip)
(defparameter *dessert-ops*
  (list (op 'eat-ice-cream
            :preconds '(has-ice-cream)
            :add-list '(ate-ice-cream ate-dessert)
            :del-list '(has-ice-cream))
        (op 'get-free-ice-cream
            :preconds '(bought-the-cake ate-the-cake)
            :add-list '(has-ice-cream)
            :del-list nil)
        (op 'eat-the-cake
            :preconds '(has-cake)
            :add-list '(ate-the-cake ate-dessert)
            :del-list '(has-cake))
        (op 'buy-the-cake
            :preconds '(has-money)
            :add-list '(has-cake bought-the-cake)
            :del-list '(has-money))))

(defvar *final-goals*)

(defun GPS (state goals &optional (*ops* *ops*))
  "General Problem Solver: from state, achieve goals using *ops*."
  (let ((*final-goals* goals))
    (find-all-if #'action-p
                 (achieve-all (cons '(start) state) goals nil))))

(defun achieve-each (state goals goal-stack)
  "Achieve each goal, and make sure they still hold at the end."
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (prog1 (setf current-state
                                     (achieve current-state g goal-stack))
                          (when (subsetp *final-goals* current-state :test #'equal)
                            (return-from achieve-each current-state))))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))

(defun apply-op (state goal op goal-stack)
  "Return a new, transformed state if op is applicable."
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state (op-preconds op) 
                             (cons goal goal-stack))))
    (cond ((subsetp *final-goals* state2 :test #'equal) state2)
          ;; Return an updated state
          (state2 (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
                  (append (remove-if #'(lambda (x) 
                                         (member-equal x (op-del-list op)))
                                     state2)
                          (op-add-list op))))))

;;; 4.4
(defun achieve (state goal goal-stack remaining-goals)
  "A goal is achieved if it already holds,
  or if there is an appropriate op for it that is applicable."
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op)
                     (achieve-all (apply-op state goal op goal-stack)
                                  remaining-goals
                                  goal-stack))
                 (appropriate-ops goal state))))) 

(defun achieve-each (state goals goal-stack)
  "Achieve each goal, and make sure they still hold at the end."
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (prog1 (setf current-state
                                     (achieve current-state
                                              g
                                              goal-stack
                                              (remove g goals)))
                          (when (subsetp *final-goals* current-state :test #'equal)
                            (return-from achieve-each current-state))))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))
