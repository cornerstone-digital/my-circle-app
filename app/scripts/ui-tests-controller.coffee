'use strict'

angular.module('smartRegisterApp')
.controller 'UITestsCtrl', ['$rootScope', '$scope', 'SettingsService','$location', ($rootScope, $scope, SettingsService, $location) ->
  $scope.today = ->
    $scope.dt = new Date()

  $scope.today()

  $scope.clear = ->
    $scope.dt = null

  # Disable weekend selection
  $scope.disabled = (date, mode) ->
    mode is "day" and (date.getDay() is 0 or date.getDay() is 6)

  $scope.toggleMin = ->
    $scope.minDate = (if $scope.minDate then null else new Date())

  $scope.toggleMin()

  $scope.open = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()
    $scope.opened = true

  $scope.dateOptions =
    formatYear: "yy"
    startingDay: 1

  $scope.initDate = new Date("2016-15-20")
  $scope.formats = [
    "dd-MMMM-yyyy"
    "yyyy/MM/dd"
    "dd.MM.yyyy"
    "shortDate"
  ]

  $scope.format = $scope.formats[0]
]