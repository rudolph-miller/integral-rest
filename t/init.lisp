(in-package :cl-user)
(defpackage integral-rest-test.init
  (:use :cl
        :prove
        :integral)
  (:export :user-id
           :user-name))
(in-package :integral-rest-test.init)

(syntax:use-syntax :annot)

@export
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

@export
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

@export
(defmacro with-init-users (&body body)
  `(let ((*users* nil)
         (*last-id* 0))
     ,@body))
