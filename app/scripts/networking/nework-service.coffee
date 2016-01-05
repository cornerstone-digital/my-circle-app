angular.module('smartRegisterApp')
.factory 'NetworkService', ['$rootScope','MessagingService', ($rootScope, MessagingService) ->
  isOnline: ->
    console.log $rootScope.online
    $rootScope.online

]
