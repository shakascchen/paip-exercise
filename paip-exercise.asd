#|
  This file is a part of paip-exercise project.
|#

(defsystem "paip-exercise"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:alexandria
               :anaphora
               :paip)
  :components ((:module "src"
                :components
                ((:file "chap3")
                 (:file "eliza-basic")
                 (:file "chap5"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "paip-exercise-test"))))
