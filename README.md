# Integral-Rest - REST APIs for Integral DAO Table.

[![Build Status](https://circleci.com/gh/Rudolph-Miller/integral-rest.svg?style=shield)](https://circleci.com/gh/Rudolph-Miller/integral-rest)
[![Quicklisp dist](http://quickdocs.org/badge/integral-rest.svg)](http://quickdocs.org/integral-rest/)

## Usage
```Lisp
(defclass user ()
  ((id :initarg :id
       :primary-key t)
   (name :initarg :name))
  (:metaclass <dao-table-class>))

(set-rest-app)

(clack:clackup *rest-app*)
```

## Installation

```Lisp
(ql:quickload :integral-rest)
```

## API

### set-rest-app

```Lisp
(defclass user ()
  ((id :initarg :id
       :primary-key t
       :accessor user-id)
   (name :initarg :name
         :accessor user-name))
  (:metaclass integral:<dao-table-class>))

(set-rest-app)
;; This sets REST API app to *rest-app*.

(defvar *my-rest-app* (set-rest-app))
;; (set-rest-app) also returns REST API app.

(set-rest-app (list (find-class 'user)))
;; (set-rest-app) can take list of class. (optional)
```

- sets REST API app to `*rest-app*`.
- returns REST API app.
- REST API app has these routing rules below.
  - `"/api/users" :GET`
  - `"/api/users" :POST`
  - `"/api/users/:id" :GET`
  - `"/api/users/:id" :PUT`
  - `"/api/users/:id" :DELETE`

```Lisp
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
```

### routing-rules

```Lisp
(defclass user ()
  ((id :initarg :id
       :primary-key t
       :accessor user-id)
   (name :initarg :name
         :accessor user-name))
  (:metaclass integral:<dao-table-class>))

(set-rest-app)

(routing-rules *rest-app*)
;; => '(("/api/users" :GET) ("/api/users" :POST) ("/api/users/:id" :GET)
;;      ("/api/users/:id" :PUT) ("/api/users/:id" :DELETE))
```

- returns list of routing rules the app has.

## Author

* Rudolph-Miller

## See Also

- [Integral](https://github.com/fukamachi/integral)

## Copyright

Copyright (c) 2015 Rudolph-Miller

## License

Licensed under the MIT License.
