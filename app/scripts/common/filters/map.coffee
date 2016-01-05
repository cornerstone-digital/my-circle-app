'use strict';

###
Transforms an array of objects into an array of a particular property of each object.
###
angular.module('smartRegisterApp')
  .filter 'map', [->
    (input, property) ->
      _.pluck input, property
  ]
