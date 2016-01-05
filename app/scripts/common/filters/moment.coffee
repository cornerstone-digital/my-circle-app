'use strict'

angular.module('smartRegisterApp')
  .filter 'moment', [->
    (date, format) ->
      moment(date).format(format)
  ]
