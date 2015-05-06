(in-package :cl-user)
(defpackage integral-rest.route
  (:use :cl
        :integral
        :ningle
        :jonathan
        :integral-rest.util
        :integral-rest.api)
  (:import-from :integral.table
                :table-primary-key))
(in-package :integral-rest.route)

(syntax:use-syntax :annot)

@export
(defvar *api-prefix* "api")

@export
(defvar *api-conjunctive-string* "/")

@export
(defvar *params-case-insensitive-p* t)

(defun get-value (key alist)
  (flet ((sub (key &key (test #'equal))
           (cdr (assoc key alist :test test))))
    (or (sub key)
        (when *params-case-insensitive-p*
          (sub key :test #'string-equal)))))

@export
(defgeneric api-path (table)
  (:method ((table <dao-table-class>))
    (format nil "/~{~a~^/~}"
            (append (when *api-prefix*
                      (list *api-prefix*))
                    (list (plural-name-of table))))))

@export
(defgeneric resources-path (table)
  (:method ((table <dao-table-class>))
    (api-path table)))

@export
(defgeneric resource-path (table)
  (:method ((table <dao-table-class>))
    (let ((primary-key-slots
            (loop with primary-key-names = (table-primary-key table)
                  for slot in (c2mop:class-direct-slots table)
                  for name = (c2mop:slot-definition-name slot)
                  when (member name primary-key-names)
                    collecting slot)))
      (format nil
              (format nil "~a/~~{~~a~~^~a~~}" (api-path table) *api-conjunctive-string*)
              (mapcar #'(lambda (slot)
                          (format nil ":~(~a~)" (slot-initarg slot)))
                      primary-key-slots)))))

(defun pk-action (fn table method)
  (let ((primary-key-names (mapcar #'symbol-name (table-primary-key table))))
    (lambda (params)
      (apply fn table method
             (loop for name in primary-key-names
                   collecting (get-value name params))))))

(defun kv-action (fn table method)
  (let ((slots (c2mop:class-direct-slots table)))
    (lambda (params)
      (apply fn table method
             (loop for slot in slots
                   for initarg = (slot-initarg slot)
                   for name = (c2mop:slot-definition-name slot)
                   for value = (get-value name params)
                   when value
                     nconc (list initarg value))))))

@export
(defgeneric resources-action (table method)
  (:method ((table <dao-table-class>) (method (eql :get)))
    (declare (ignore method))
    (lambda (params)
      (declare (ignore params))
      (resources table :get)))

  (:method ((table <dao-table-class>) (method (eql :post)))
    (kv-action #'resources table method)))

@export
(defgeneric resource-action (table method)
  (:method ((table <dao-table-class>) (method (eql :get)))
    (pk-action #'resource table method))

  (:method ((table <dao-table-class>) (method (eql :put)))
    (kv-action #'resource table method))

  (:method ((table <dao-table-class>) (method (eql :delete)))
    (pk-action #'resource table method)))

