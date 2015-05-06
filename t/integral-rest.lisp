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
    (is (length (myway.mapper::mapper-routes (ningle.app::mapper (set-rest-app (list *user-table*)))))
        5
        "can set the valid number of routes.")))

(finalize)
