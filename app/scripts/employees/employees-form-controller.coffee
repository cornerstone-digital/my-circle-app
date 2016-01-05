'use strict'

angular.module('smartRegisterApp')
.controller 'EmployeeFormCtrl', ['$rootScope', '$scope','$location', '$timeout', '$http', 'employee', 'venues', 'venue', 'Auth', 'EmployeeService','MessagingService', 'ValidationService', ($rootScope, $scope, $location, $timeout, $http, employee, venues, venue, Auth, EmployeeService, MessagingService, ValidationService) ->
  $scope.employee = employee
  $scope.credential = _.find $scope.employee.credentials, (it) -> it.type is 'PIN'
  $scope.venues = venues
  $scope.venue = venue

  unless $scope.credential
    $scope.credential = {type: 'PIN'}

  $scope.roles = [
    group:
      name: 'MERCHANT_ADMINISTRATORS'
    label: 'Merchant admin'
  ]

  $scope.isInGroup = (employee, groupName) ->
    EmployeeService.isInGroup(employee, groupName)

  if $scope.isInGroup employee, 'MERCHANT_EMPLOYEE'
    $scope.roles.push({
      group:
        name: 'MERCHANT_EMPLOYEE'
      label: 'Staff'
    })

  if $scope.isInGroup employee, 'VENUE_EMPLOYEE'
    $scope.roles.push({
        group:
          name: 'VENUE_EMPLOYEE'
        label: 'Staff'
    })

  if $scope.isInGroup employee, 'PLATFORM_ADMINISTRATORS'
    $scope.roles.push({
        group:
          name: 'PLATFORM_ADMINISTRATORS'
        label: 'Global admin'
    })

  $scope.switchEmployeeType = (employeeType) ->
    $scope.employee["type"] = employeeType

    if employeeType == 'Venue'
      $scope.employee.venueId = $scope.venues[0].id
    else
      delete $scope.employee.venueId

  $scope.isVenueStaffMember = (employee) ->
    $scope.employee.venueId? and angular.isNumber(parseInt($scope.employee.venueId))

  $scope.switchToGroup = (group) ->
    for role in $scope.roles
      $scope.employee.groups = _.reject $scope.employee.groups, (it) -> it.name is role.group.name
    $scope.employee.groups.push group

  $scope.updateCredentials = (employee, credential, callback) ->
    if credential?.token
      errorCallback = (response, status) ->
        console.error "failed to create credentials", status, response
        $scope.error = "#{response.reference}: #{response.message}"
        $scope.employeeForm.pin.$setValidity 'unique', false if status is 409
        delete $scope.locked

      if credential.id?
        newCredential = angular.copy(credential)

        delete newCredential.id
        $http.put("api://api/merchants/#{Auth.getMerchant().id}/employees/#{employee.id}/credentials/#{credential.id}", newCredential)
          .success(callback)
          .error(errorCallback)
      else
        $http.post("api://api/merchants/#{Auth.getMerchant().id}/employees/#{employee.id}/credentials", credential)
          .success(callback)
          .error(errorCallback)
    else if credential?.id?
      $http.delete("api://api/merchants/#{Auth.getMerchant().id}/employees/#{employee.id}/credentials/#{credential.id}")
      .success ->
        employee.credentials = _.reject employee.credentials, (it) -> it.id is credential.id
        callback()
      .error (response, status) ->
        console.error "failed to delete credential", status, response
        $scope.error = "#{response.reference}: #{response.message}"
        delete $scope.locked
    else
      callback()

  $scope.showMessage = (messageText) ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("success", messageText, 'GlobalErrors')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('GlobalErrors')

  $scope.reset = ->
    MessagingService.resetMessages()
    ValidationService.reset()

    if $scope.employee.id?
      EmployeeService.getById($scope.employee.id).then((response)->
        $scope.employee = response
      )
    else
      $scope.employee = EmployeeService.new()

  $scope.save = (redirect) ->

    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Employee')

    if(!MessagingService.hasMessages('Employee').length)
      $scope.locked = true

      employee = $scope.employee
      credential = $scope.credential

      EmployeeService.save(employee, credential)

  $scope.cancel = ->
    delete $scope.employee
    delete $scope.credential
    delete $scope.error

  $scope.showDataChangedMessage = ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("warning", "Your employee data has changed. Don't forget to press the 'Save' button.", 'Employee')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Employee')

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
