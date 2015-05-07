(in-package :cl-user)
(defpackage integral-rest
  (:use :cl
        :integral
        :ningle)
  (:import-from :alexandria
                :symbolicate)
  (:import-from :integral-rest.util
                :*convert-intgral-slot-name-into-downcase*
                :singular-name-of
                :plural-name-of)
  (:import-from :integral-rest.api
                :resources
                :resource)
  (:import-from :integral-rest.route
                :*api-prefix*
                :*api-conjunctive-string*
                :*params-case-insensitive-p*
                :resources-path
                :resource-path
                :resources-action
                :resource-action)
  (:export ;; util
           :*convert-intgral-slot-name-into-downcase*
           :singular-name-of
           :plural-name-of

           ;; api
           :resources
           :resource

           ;; route
           :*api-prefix*
           :*api-conjunctive-string*
           :*params-case-insensitive-p*
           :resources-path
           :resource-path
           :resources-action
           :resource-action

           ;; main
           :*rest-app*
           :set-rest-app))
(in-package :integral-rest)

(defvar *rest-app*)

(defun set-rest-app (&optional (tables (c2mop:class-direct-subclasses (find-class '<dao-class>))))
  (let ((app (make-instance '<app>)))
    (macrolet ((set-routes (resource-or-resources methods)
                 `(loop for method in ,methods
                        for action = (,(symbolicate resource-or-resources '-action) table method)
                        do (setf (route app (,(symbolicate resource-or-resources '-path) table) :method method)
                                 action))))
      (loop for table in tables
            do (set-routes resources '(:get :post))
               (set-routes resource '(:get :put :delete))))
    (setf *rest-app* app)))
