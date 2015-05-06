# Integral-Rest - REST APIs for Integral DAO Table.

[![Build Status](https://travis-ci.org/Rudolph-Miller/integral-rest.svg)](https://travis-ci.org/Rudolph-Miller/integral-rest)

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

## Author

* Rudolph-Miller

## Copyright

Copyright (c) 2015 Rudolph-Miller

## License

Licensed under the MIT License.
