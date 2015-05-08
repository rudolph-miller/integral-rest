#|
  This file is a part of integral-rest project.
  Copyright (c) 2015 Rudolph-Miller
|#

#|
  REST APIs for Integral DAO Table.

  Author: Rudolph-Miller
|#

(in-package :cl-user)
(defpackage integral-rest-asd
  (:use :cl :asdf))
(in-package :integral-rest-asd)

(defsystem integral-rest
  :version "0.1"
  :author "Rudolph-Miller"
  :license "MIT"
  :depends-on (:alexandria
               :integral
               :ningle
               :closer-mop
               :jonathan
               :cl-inflector
               :map-set)
  :components ((:module "src"
                :components
                ((:file "integral-rest" :depends-on ("route" "api" "util"))
                 (:file "route" :depends-on ("api" "util"))
                 (:file "api" :depends-on ("util"))
                 (:file "util"))))
  :description "REST APIs for Integral DAO Table."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op integral-rest-test))))
