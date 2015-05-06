(in-package :cl-user)
(defpackage integral-rest-test.route
  (:use :cl
        :prove
        :integral
        :integral-rest.route))
(in-package :integral-rest-test.route)

(plan nil)

(finalize)
