#|
  This file is a part of paip-exercise project.
|#

(defsystem "paip-exercise"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "paip-exercise"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "paip-exercise-test"))))
