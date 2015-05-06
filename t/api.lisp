(in-package :cl-user)
(defpackage integral-rest-test.api
  (:use :cl
        :prove
        :integral
        :integral-rest.api))
(in-package :integral-rest-test.api)

(plan nil)

(defclass user ()
  ((id :initarg :id
       :accessor user-id
       :primary-key t)
   (name :initarg :name
         :accessor user-name))
  (:metaclass <dao-table-class>))

(defvar *users* nil)
(defvar *last-id* 0)

(defmethod find-dao ((table (eql (find-class 'user))) &rest values)
  (declare (ignore table))
  (find (car values) *users*
        :test #'(lambda (id user)
                  (= id (user-id user)))))

(defvar *user-table* (find-class 'user))

(defmethod insert-dao ((user user))
  (setf (user-id user) (incf *last-id*))
  (push user *users*)
  user)

(defmethod update-dao ((user user))
  (push user *users*))

(defmethod delete-dao ((user user))
  (setq *users*
        (remove-if #'(lambda (target)
                       (= (user-id user)
                          (user-id target)))
                   *users*)))

(defmethod select-dao ((table (eql (find-class 'user))) &rest expressions)
  (declare (ignore table expressions))
  (remove-duplicates *users*
                     :test #'(lambda (a b)
                               (= (user-id a)
                                  (user-id b)))))

(defmacro with-init-users (&body body)
  `(let ((*users* nil)
         (*last-id* 0))
     ,@body))

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
