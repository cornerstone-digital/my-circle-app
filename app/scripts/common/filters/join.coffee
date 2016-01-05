'use strict';

###
Joins an array into a string using a delimiter which defaults to ", ".
If given a comma-separated string instead of an array it will split and
re-join it.
###
angular.module('smartRegisterApp')
  .filter 'join', [->
    (input, delimiter = ', ') ->
      input = input.split(',') if typeof input is "string"
      input.join delimiter
  ]
