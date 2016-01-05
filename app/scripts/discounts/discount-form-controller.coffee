'use strict'

angular.module('smartRegisterApp')
.controller 'DiscountFormCtrl', ['$rootScope', '$scope','$location', '$timeout', '$http', 'discount', 'Auth', 'DiscountService','MessagingService', 'ValidationService', ($rootScope, $scope, $location, $timeout, $http, discount, Auth, DiscountService, MessagingService, ValidationService) ->
  $scope.discount = discount

  $scope.reset = ->
    MessagingService.resetMessages()
    ValidationService.reset()

    if $scope.discount.id?
      DiscountService.getById($scope.discount.id).then((response)->
        $scope.discount = response
      )
    else
      $scope.discount = DiscountService.new()

  $scope.save = (redirect) ->

    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Discount')

    if(!MessagingService.hasMessages('Discount').length)
      $scope.locked = true

      discount = $scope.discount

      DiscountService.save(discount).then((response) ->
        if(redirect)
          $rootScope.back()
        else
          $scope.locked = false
          $scope.discount = response
      , (response) ->
        console.error 'update failed'
        $scope.locked = false
      )

  $scope.showDataChangedMessage = ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("warning", "Your discount data has changed. Don't forget to press the 'Save' button.", 'Discount')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Discount')

  $scope.findNextElemByTabIndex = (tabIndex) ->
    matchedElement = angular.element( document.querySelector("[tabindex='#{tabIndex}']") )

    return matchedElement

  $scope.moveToNextTabIndex = ($event, $editable) ->
    currentElem = $editable
    nextElem = []

    # Find next available tabIndex
    if currentElem.attrs.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex)

    currentElem.save()
    currentElem.hide()

    if(nextElem.length)
      $timeout ->
        nextElem.click()
      , 10

  $scope.keypressCallback = ($event, $editable) ->
    currentElem = $editable
    nextElem = []

    # Find next available tabIndex
    if currentElem.attrs.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex)

    if $event.which == 9
      $event.preventDefault()
      currentElem.save()
      currentElem.hide()

      if(nextElem.length)
        $timeout ->
          nextElem.click()
        , 10

    if $event.which == 13
      $event.preventDefault()
      currentElem.save()
      currentElem.hide()
]
