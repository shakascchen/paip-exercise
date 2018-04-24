#|
  This file is a part of paip-exercise project.
|#

(defsystem "paip-exercise-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("paip-exercise"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "paip-exercise"))))
  :description "Test system for paip-exercise"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
