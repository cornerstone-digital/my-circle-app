'use strict'

###
Converts a camel-case string to dash-case.
###
angular.module('smartRegisterApp')
  .filter 'dashCase', [->
    (str) ->
      s = str.replace /([A-Z])/g, ($1) ->
        "-#{$1.toLowerCase()}"

      if s.charAt(0) is '-' then s.substr(1) else s
  ]
