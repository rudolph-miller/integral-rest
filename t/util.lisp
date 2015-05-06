(in-package :cl-user)
(defpackage integral-rest-test.util
  (:use :cl
        :prove
        :integral
        :integral-rest-test.init
        :integral-rest.util))
(in-package :integral-rest-test.util)

(plan nil)

(subtest "table-initargs"
  (is (table-initargs 'user)
      (list :id :name)
      "can return initargs in list."))

(finalize)
