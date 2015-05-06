(in-package :cl-user)
(defpackage integral-rest.api
  (:use :cl
        :ningle
        :integral
        :integral-rest.util)
  (:import-from :integral.table
                :table-primary-key))
(in-package :integral-rest.api)

(syntax:use-syntax :annot)

@export
(defgeneric resources (model method &rest args)
  (:method ((table <dao-table-class>) (method (eql :get)) &rest args)
    (declare (ignore method args))
    (select-dao table)))

@export
(defgeneric resource (model method &rest args)
  (:method ((table <dao-table-class>) (method (eql :get)) &rest args)
    (declare (ignore method))
    (apply #'find-dao table args))

  (:method ((table <dao-table-class>) (method (eql :post)) &rest args)
    (declare (ignore method))
    (apply #'create-dao table args))

  (:method ((table <dao-table-class>) (method (eql :put)) &rest args)
    (let* ((values (loop for slot in (table-primary-key table)
                        for key = (slot-initarg slot)
                        collecting (getf args key)))
           (obj (apply #'find-dao table values)))
      obj))

  (:method ((table <dao-table-class>) (method (eql :delete)) &rest args)
    (declare (ignore method args))))
