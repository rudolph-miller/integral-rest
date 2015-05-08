(in-package :cl-user)
(defpackage integral-rest-test
  (:use :cl
        :prove
        :integral-rest
        :integral-rest-test.init))
(in-package :integral-rest-test)

;; NOTE: To run this test file, execute `(asdf:test-system :integral-rest)' in your Lisp.

(plan nil)

(subtest "set-rest-app"
  (with-init-users
    (set-rest-app (list *user-table*))
    (is-type *rest-app*
             'ningle:<app>
             "can set the instance of <app> to *rest-app*.")

    (is (length (myway.mapper::mapper-routes (ningle.app::mapper *rest-app*)))
        5
        "can set the valid number of routes.")))

(subtest "routing-rules"
  (with-init-users
    (set-rest-app (list *user-table*))
    (is (routing-rules *rest-app*)
        '(("/api/users" :GET)
          ("/api/users" :POST)
          ("/api/users/:id" :GET)
          ("/api/users/:id" :PUT)
          ("/api/users/:id" :DELETE))
        "can return the valid list of ruting rules.")))

(finalize)
