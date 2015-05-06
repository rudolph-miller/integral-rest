(in-package :cl-user)
(defpackage integral-rest
  (:use :cl)
  (:import-from :integral-rest.util
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
  (:export :singular-name-of
           :plural-name-of
           :resources
           :resource
           :*api-prefix*
           :*api-conjunctive-string*
           :*params-case-insensitive-p*
           :resources-path
           :resource-path
           :resources-action
           :resource-action))
(in-package :integral-rest)
