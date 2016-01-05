'use strict'

angular.module('smartRegisterHelp', [])
.run ['$rootScope', ($rootScope) ->

  $rootScope.mode = 'app'

  if Modernizr?.touch
    $ ->
      FastClick.attach document.body
]
