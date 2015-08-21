(defpackage sample
  (:use :cl
        :integral
        :integral-rest))
(in-package :sample)

(connect-toplevel :sqlite3 :database-name ":memory:")

(defclass user ()
  ((id :initarg :id
       :type integer
       :primary-key t
       :accessor user-id)
   (name :initarg :name
         :type string
         :accessor user-name))
  (:metaclass integral:<dao-table-class>))

(ensure-table-exists (find-class 'user))

(set-rest-app)

(clack:clackup *rest-app*)
;; => Listening on localhost:5000.

(create-dao 'user :name "Rudolph")
;; => #<USER id: 1>

(dex:get "http://localhost:5000/api/users")
;; => "[{\"id\":1,\"name\":\"Rudolph\"}]"

(dex:get "http://localhost:5000/api/users/1")
;; => "{\"id\":1,\"name\":\"Rudolph\"}"

(dex:post "http://localhost:5000/api/users" :content '(("name" . "Miller")))
;; => "{\"id\":2,\"name\":\"Miller\"}"

(find-dao 'user 2)
;; => #<USER id: 2 name: "Miller">

(dex:put "http://localhost:5000/api/users/2" :content '(("name" . "Tom")))
;; => "{\"id\":2,\"name\":\"Tom\"}"

(find-dao 'user 2)
;; => #<USER id: 2 name: "Tom">

(dex:delete "http://localhost:5000/api/users/2")
;; => "{\"id\":2,\"name\":\"Tom\"}"

(find-dao 'user 2)
;; => NIL
