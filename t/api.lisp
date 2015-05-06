(in-package :cl-user)
(defpackage integral-rest-test.api
  (:use :cl
        :prove
        :integral
        :integral-rest-test.init
        :integral-rest.api))
(in-package :integral-rest-test.api)

(plan nil)

(subtest "resources"
  (with-init-users
    (let ((user (create-dao 'user :name "Rudolph")))
      (subtest ":get"
        (is (resources *user-table* :get)
            (list user)
            "can return the valid list.")))))

(subtest "resource"
  (with-init-users
    (let ((user (create-dao 'user :name "Rudolph")))
      (subtest ":get"
        (is (resource *user-table* :get 1)
            user
            "can return the object."))

      (subtest ":post"
        (resource *user-table* :post :name "Miller")
        (ok (resource *user-table* :get 2)
            "can create the object."))

      (subtest ":put"
        (resource *user-table* :put :id 1 :name "Tom")
        (is (user-name (find-dao 'user 1))
            "Tom"
            "can update the object."))

      (subtest ":delete"
        (resource *user-table* :delete 1)
        (ok (not (find-dao 'user 1))
            "can delete the object.")))))

(finalize)
