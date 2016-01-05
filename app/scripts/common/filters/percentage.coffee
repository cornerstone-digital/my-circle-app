'use strict'

angular.module('smartRegisterApp')
.filter 'percentage', [->
  (value) ->
    "#{value * 100}%"
]
