'use strict'

angular.module('smartRegisterApp')

.filter('afterLast', [->
  (it, delimiter) ->
    it.substring(it.lastIndexOf(delimiter) + 1)
])
