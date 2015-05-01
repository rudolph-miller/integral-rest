(in-package :cl-user)
(defpackage integral-rest-test.util
  (:use :cl
   :prove
        :integral
   :integral-rest.util))
(in-package :integral-rest-test.util)

(plan nil)

(defclass user ()
  ((id :initarg :id)
   (name :initarg :name))
  (:metaclass <dao-table-class>))

(subtest "table-initargs"
  (is (table-initargs 'user)
      (list :id :name)
      "can return initargs in list."))

(finalize)
