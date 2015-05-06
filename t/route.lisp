(in-package :cl-user)
(defpackage integral-rest-test.route
  (:use :cl
        :prove
        :integral
        :integral-rest.route))
(in-package :integral-rest-test.route)

(plan nil)

(defclass user ()
  ((id :primary-key t
       :initarg :id
       :accessor user-id))
  (:metaclass <dao-table-class>))

(defvar *user-table* (find-class 'user))

(subtest "api-path"
  (is (api-path *user-table*)
      "/api/users"
      "with *api-prefix*.")

  (let ((*api-prefix* nil))
    (is (api-path *user-table*)
        "/users"
        "without *api-prefix*.")))

(finalize)
