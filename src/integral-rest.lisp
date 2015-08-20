(in-package :cl-user)
(defpackage integral-rest
  (:use :cl
        :integral)
  (:import-from :ningle
                :route)
  (:import-from :ningle.app
                :mapper)
  (:import-from :myway.mapper
                :mapper-routes)
  (:import-from :myway.route
                :route-rule)
  (:import-from :myway.rule
                :rule-url
                :rule-methods)
  (:import-from :map-set
                :ms-map)
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
           :set-rest-app
           :routing-rules))
(in-package :integral-rest)

(defclass <app> (ningle:<app>) ())

(defvar *rest-app* (make-instance '<app>))

@doc
"sets REST API app to *rest-app* and returns REST API app."
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
    (setf (mapper *rest-app*)
          (mapper app))
    app))

@doc
"returns list of routing rules the app has."
(defun routing-rules (&optional (app *rest-app*))
  (loop for route in  (mapper-routes (mapper app))
        for rule = (route-rule route)
        for url = (rule-url rule)
        for methods = (ms-map 'cons #'identity (rule-methods rule))
        collecting (cons url methods)))
