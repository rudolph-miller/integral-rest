(in-package :cl-user)
(defpackage integral-rest.util
  (:use :cl
        :integral
        :jonathan))
(in-package :integral-rest.util)

(syntax:use-syntax :annot)

@export
(defvar *convert-intgral-slot-name-into-downcase* t)

@export
(defun slot-initarg (slot)
  (car (c2mop:slot-definition-initargs slot)))

@export
(defgeneric table-initargs (table)
  (:method ((table symbol))
    (table-initargs (find-class table)))
  (:method ((table class))
    (loop for slot in (c2mop:class-direct-slots table)
          for initarg = (slot-initarg slot)
          when initarg
            collecting initarg)))

@export
(defgeneric singular-name-of (table)
  (:method ((table <dao-table-class>))
    (string-downcase (class-name table))))

@export
(defgeneric plural-name-of (table)
  (:method ((table <dao-table-class>))
    (cl-inflector:plural-of (singular-name-of table))))

(defmethod %to-json ((obj <dao-class>))
  (with-object
    (loop for slot in (c2mop:class-direct-slots (class-of obj))
          for name = (c2mop:slot-definition-name slot)
          for type = (c2mop:slot-definition-type slot)
          for key = (symbol-name name)
          when (and (not (equal key "%SYNCED"))
                    (slot-boundp obj name))
            do (write-key-value (or (when *convert-intgral-slot-name-into-downcase*
                                      (string-downcase key))
                                    key)
                                (or (slot-value obj name)
                                    (and (not (eql type 'cons)) :null))))))
