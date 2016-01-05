'use strict'

angular.module('smartRegisterApp')
.factory 'ValidationService', ['$rootScope', 'MessagingService', ($rootScope, MessagingService) ->
  validate: (group) ->
    $rootScope.$broadcast 'validate-data:validate', (group)

  reset: ->
    $rootScope.$broadcast 'validate-data:reset'

  isRequired: (value) ->
    value = String(value)

    return value != 'undefined' and angular.isString(value) and value.length

  isNumeric: (value) ->
    return angular.isNumber(Number(value))

  isEmail: (value) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    return re.test(value)

  isMatch: (value, valueToMatch) ->
    return angular.equals(value, valueToMatch)

  isPostcode: (value, locale) ->
    re = /^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$/
    return re.test(value)
]
