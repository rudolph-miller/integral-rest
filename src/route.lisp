(in-package :cl-user)
(defpackage integral-rest.route
  (:use :cl
        :integral
        :ningle
        :jonathan
        :integral-rest.util))
(in-package :integral-rest.route)

(syntax:use-syntax :annot)

@export
(defvar *api-prefix* "api")

@export
(defgeneric api-path (table)
  (:method ((table <dao-table-class>))
    (format nil "/~{~a~^/~}" (append (when *api-prefix*
                                       (list *api-prefix*))
                                     (list (plural-name-of table))))))
