(in-package :cl-user)
(defpackage integral-rest-test.route
  (:use :cl
        :prove
        :integral
        :integral-rest-test.init
        :integral-rest.route))
(in-package :integral-rest-test.route)

(plan nil)

(subtest "api-path"
  (is (api-path *user-table*)
      "/api/users"
      "with *api-prefix*.")

  (let ((*api-prefix* nil))
    (is (api-path *user-table*)
        "/users"
        "without *api-prefix*.")))

(subtest "resources-action"
  (with-init-users
    (let ((user (create-dao 'user :name "Rudalph")))
      (subtest ":get"
        (is (funcall (resources-action *user-table* :get) nil)
            (list user)
            "can return the valid lambda."))

      (subtest ":post"
        (let ((user2 (funcall (resources-action *user-table* :post)
                              '(("name" . "Miller")))))
          (is (find-dao 'user 2)
              user2
              "can return the valid lambda."))))))


(subtest "resource-action"
  (with-init-users
    (let ((user (create-dao 'user :name "Rudolph")))
      (subtest ":get"
        (is (funcall (resource-action *user-table* :get)
                     '(("id" . 1)))
            user
            "can return the valid lambda."))

      (subtest ":put"
        (funcall (resource-action *user-table* :put)
                 '(("id" . 1) ("name" . "Tom")))
        (is (user-name (find-dao 'user 1))
            "Tom"
            "can return the valid lambda."))

      (subtest ":delete"
        (funcall (resource-action *user-table* :delete)
                 '(("id" . 1)))
        (ok (not (find-dao 'user 1))
            "can return the valid lambda.")))))

(finalize)
