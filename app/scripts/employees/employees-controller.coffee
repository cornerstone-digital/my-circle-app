'use strict'

angular.module('smartRegisterApp')
.controller 'EmployeesCtrl', ['$rootScope', '$scope', '$http', '$location', '$route', 'Employee', 'employees', 'venue', 'venues', 'Auth', 'Config', 'SettingsService', 'EmployeeService', ($rootScope, $scope, $http, $location, $route, Employee, employees, venue, venues, Auth, Config, SettingsService, EmployeeService) ->

  $scope.employees = employees
  $scope.venue  = venue
  $scope.venues = venues

  $scope.roles = [
    group:
      name: 'MERCHANT_EMPLOYEE'
    label: 'Staff'
  ,
    group:
      name: 'MERCHANT_ADMINISTRATORS'
    label: 'Merchant admin'
  ,
    group:
      name: 'PLATFORM_ADMINISTRATORS'
    label: 'Global admin'
  ]

  unless Auth.isMemberOf 'PLATFORM_ADMINISTRATORS'
    $scope.roles = $scope.roles.slice(0, _.lastIndexOf $scope.roles, (it) -> Auth.isMemberOf it.group.name)

  $scope.create = ->
    $location.path "/venues/#{venue.id}/employees/add"

  $scope.edit = (employee) ->
    $location.path "/venues/#{$scope.venue.id}/employees/edit/#{employee.id}"

  $scope.remove = (employee) ->
    EmployeeService.remove(employee).then(->
      index = $scope.employees.indexOf(employee)
      $scope.employees.splice index, 1
    , ->
      console.error "could not delete", employee
      $scope.$broadcast "delete:failed", employee
    )

  updateCredentials = (employee, credential, callback) ->
    if credential?.token
      errorCallback = (response, status) ->
        console.error "failed to create credentials", status, response
        $scope.error = "#{response.reference}: #{response.message}"
        $scope.employeeForm.pin.$setValidity 'unique', false if status is 409
        delete $scope.locked

      if credential.id?
        $http.put("api://api/merchants/#{Auth.getMerchant().id}/employees/#{employee.id}/credentials/#{credential.id}", credential)
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

  $scope.save = ->
    if $scope.employeeForm.$valid
      $scope.locked = true

      # defensive copy in case user closes form before API call returns
      employee = $scope.employee
      credential = $scope.credential

      if employee.id?
        employee.$update ->
          updateCredentials employee, credential, ->
            for index in [0...$scope.employees.length]
              $scope.employees[index] = employee if $scope.employees[index].id is employee.id
            delete $scope.employee
            delete $scope.credential
            delete $scope.locked
        , (response) ->
          console.error "failed to update employee '#{employee.name}'"
          $scope.error = "#{response.data.reference}: #{response.data.message}"
          delete $scope.locked
      else
        employee.$save (response) ->

          # employee resource removes the credentials before requesting and therefore the response will wipe them out
          employee.credentials = [credential]

          updateCredentials employee, credential, ->
            $scope.employees.push employee
            delete $scope.employee
            delete $scope.credential
            delete $scope.locked
        , (response) ->
          console.error "failed to save employee '#{employee.name}'"
          $scope.error = "#{response.data.reference}: #{response.data.message}"
          delete $scope.locked

  $scope.cancel = ->
    delete $scope.employee
    delete $scope.credential
    delete $scope.error

  $scope.switchToGroup = (group) ->
    for role in $scope.roles
      $scope.employee.groups = _.reject $scope.employee.groups, (it) -> it.name is role.group.name
    $scope.employee.groups.push group

  $scope.hasModuleEnabled = (moduleName) ->
    SettingsService.hasModuleEnabled moduleName

  $scope.confirmedDelete = (employee) ->
    $scope.employeeToDelete = employee

  $scope.closeConfirm = ->
    delete $scope.employeeToDelete

  $scope.confirmYes = ->
    $scope.remove $scope.employeeToDelete
    $scope.closeConfirm()

  $scope.hasMultipleVenues = ->
    if($scope.venues.length > 1)
      return true
    else
      return false

  $scope.switchVenue = (venue) ->
    $scope.$broadcast 'venue:switch', venue

  $scope.$on 'venue:switch', (event, venue) ->
    $rootScope.credentials.venue = venue
    $route.reload()
]
