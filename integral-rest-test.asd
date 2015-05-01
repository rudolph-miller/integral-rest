#|
  This file is a part of integral-rest project.
  Copyright (c) 2015 Rudolph-Miller
|#

(in-package :cl-user)
(defpackage integral-rest-test-asd
  (:use :cl :asdf))
(in-package :integral-rest-test-asd)

(defsystem integral-rest-test
  :author "Rudolph-Miller"
  :license "MIT"
  :depends-on (:integral-rest
               :prove
               :integral)
  :components ((:module "t"
                :components
                ((:test-file "integral-rest")
                 (:test-file "util"))))

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
