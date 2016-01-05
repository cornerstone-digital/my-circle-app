'use strict'

# This simply prevents the tests from rejecting an empty environment setting and/or spamming the logs with warnings about invalid environment names
angular.module('mockEnvironment', []).run ['$rootScope', ($rootScope) ->
  $rootScope.env = 'test'
]
