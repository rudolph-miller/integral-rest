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
    (select-dao table))

  (:method ((table <dao-table-class>) (method (eql :post)) &rest args)
    (declare (ignore method))
    (apply #'create-dao table args)))

@export
(defgeneric resource (model method &rest args)
  (:method ((table <dao-table-class>) (method (eql :get)) &rest args)
    (declare (ignore method))
    (apply #'find-dao table args))

  (:method ((table <dao-table-class>) (method (eql :put)) &rest args)
    (multiple-value-bind (primary-values update-kvs)
        (loop with primary-keys = (table-primary-key table)
              for slot in (c2mop:class-direct-slots table)
              for initarg = (slot-initarg slot)
              for slot-name = (c2mop:slot-definition-name slot)
              for value = (getf args initarg)
              when (member slot-name primary-keys)
                collecting value into primary-values
              when value
                collecting (cons slot-name value) into update-kvs
              finally (return (values primary-values update-kvs)))
      (let ((obj (apply #'find-dao table primary-values)))
        (loop for (key . val) in update-kvs
              do (setf (slot-value obj key) val))
        (update-dao obj))))

  (:method ((table <dao-table-class>) (method (eql :delete)) &rest args)
    (delete-dao (apply #'find-dao table args))))
