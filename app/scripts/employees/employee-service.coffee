angular.module('smartRegisterApp')
.factory 'EmployeeService', ['$rootScope', '$http', '$route', '$timeout', '$location', 'ResourceWithPaging','ResourceNoPaging','Auth','VenueService', 'MessagingService', ($rootScope, $http, $route, $timeout, $location, ResourceWithPaging, ResourceNoPaging,Auth, VenueService, MessagingService) ->
  Employees = {}

  Employees.new = ->
    employee = ResourceNoPaging.one("merchants", $rootScope.credentials.merchant?.id).one("employees")
    employee.enabled = true
    employee.isNew = true
    employee.credentials = [
      {type: 'PIN'}
    ]
    employee.groups = [
      {
        name: 'MERCHANT_EMPLOYEE'
      }
    ]

    if $route.current.params.venueId?
      employee["type"] = "Venue"
      employee.venueId = $route.current.params.venueId
    else
      employee["type"] = "Merchant"
      employee.merchantId = $rootScope.credentials.merchant.id

    return employee

  Employees.getGridListByVenue = (venue, params) ->
    merchantId = $rootScope.credentials?.merchant?.id
    venue = venue ? $rootScope.credentials?.venue
    params = params ? {}

    gridList = []

    ResourceNoPaging.one("merchants", merchantId).one("venues", venue.id).getList("employees", params).then((employees) ->
      angular.forEach employees, (employee, index) ->

        activeText = "Active"
        activeText = "Active" if !employee.enabled

        gridRow =
          id: employee.id
          firstname: employee.firstname
          lastname: employee.lastname
          displayName: employee.displayName
          venueId: venue.id
          venueName: venue.name
          email: employee.email
          active: activeText

        gridList.push(gridRow)

      return gridList
    )

  Employees.getList = (merchantId, params) ->

    merchantId = merchantId ? $rootScope.credentials?.merchant?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", merchantId).getList("employees", params)

  Employees.getGridList = (merchantId, params) ->
    merchantId = merchantId ? $rootScope.credentials?.merchant?.id
    params = params ? {}

    gridList = []

    ResourceNoPaging.one("merchants", merchantId).getList("employees", params).then((employees) ->

      # Add merchant employees to the list
      angular.forEach employees, (employee, index) ->

        activeText = "Active"
        activeText = "Active" if !employee.enabled

        gridRow =
          id: employee.id
          firstname: employee.firstname
          lastname: employee.lastname
          displayName: employee.displayName
          email: employee.email
          active: activeText

        gridList.push(gridRow)

      return gridList
    )

  Employees.getById = (employeeId, params) ->
    params = params ? {full:true}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("employees", employeeId).get()

  Employees.getByVenueId = (employeeId, venueId, params) ->
    params = params ? {full:true}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).one("employees", employeeId).get()

  Employees.bulkDeleteVenueEmployees = (employeeIds, venueId) ->
    $http(
      url: "api://api/merchants/#{$rootScope.credentials?.merchant?.id}/venues/#{venueId}/employees"
      method: "DELETE"
      headers: {'Content-Type': 'application/json;charset=utf-8'}
      data: {
        ids: employeeIds
      }
    ).success (data, status, headers, config) ->
      return data
    , (error) ->
      console.log error
      return

  Employees.bulkDeleteMerchantEmployees = (employeeIds, merchantId) ->
    # /{merchantId}/employees
    $http(
      url: "api://api/merchants/#{$rootScope.credentials?.merchant?.id}/employees"
      method: "DELETE"
      headers: {'Content-Type': 'application/json;charset=utf-8'}
      data: {
        ids: employeeIds
      }
    ).success (data, status, headers, config) ->
      return data
    , (error) ->
      console.log error
      return


  Employees.updateCredentials = (employee, credential, callback) ->
    if credential?.token
      errorCallback = (response, status) ->
        console.error "failed to create credentials", status, response

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
    else
      callback()

  Employees.save = (employee, credential) ->
    pin = _.findWhere(employee.credentials, type: 'PIN')
    if employee.credentials? and !pin.value
      delete employee.credentials

    currentVenueId = $route.current.params.venueId ? null

    if employee.isNew and not employee.id?
      # This is a new employee, let's create it
      if employee.type == "Venue"
        # Create a new venue employee
        ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", employee.venueId).post("employees", employee).then((newEmployee) ->
          Employees.updateCredentials newEmployee, credential, ->
            # Don't redirect until the success callback is invoked, otherwise request is cancelled!
            $location.path "venues/#{employee.venueId}/employees"
        )
      else if employee.type == "Merchant"

        # Create a new merchant employee
        ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).post("employees", employee).then((newEmployee) ->
          Employees.updateCredentials newEmployee, credential, ->
            # Don't redirect until the success callback is invoked, otherwise request is cancelled!
            $location.path "/merchant"
        )
    else
      # Existing employee
      # First lets persist the employee data in case any details have changed
      employee = ResourceNoPaging.copy(employee)

      employee.save().then((response) ->
        # Now lets update the venue association information
        if employee.type == "Venue"
          if employee.merchantId?
            console.log "Move employee from merchant to venue"
            # Move venue from merchant to venue
            ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("employees", employee.id).one("venues", employee.venueId).customPUT(employee).then((response) ->
              $location.path "/venues/#{employee.venueId}/employees/edit/#{employee.id}"
            )
          else
            # Move venue from one venue to another
            console.log "Move venue from one venue to another"
            ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", currentVenueId).one("employees", employee.id).one("venues", employee.venueId).customPUT(employee).then((response) ->
              $location.path "/venues/#{employee.venueId}/employees/edit/#{employee.id}"
            )
        else if employee.type == "Merchant"
          console.log "Move venue employee to merchant"
          #
          ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", currentVenueId).one("employees", employee.id).one("merchant").customPUT(employee).then((response) ->
            $location.path "/employees/edit/#{employee.id}"
          )
      )

  Employees.remove = (employee) ->
    if employee.venueId?
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues",employee.venueId).one("employees", employee.id).get().then((employee) ->
        employee.remove()
      )
    else
      Employees.getById().then((employee) ->
        employee.remove()
      )

  Employees.isInGroup = (employee, groupName) ->
    _.findWhere(employee.groups, name: groupName)?

  Employees.resetToken = (token, password) ->
    requestBody = {reference: token, password: password}
    apiURL = "merchants/employees/token/reset"
    ResourceNoPaging.allUrl(apiURL).customPUT(requestBody)

  Employees.requestPasswordReset = (email) ->
    requestBody = {email: email}
    apiURL = "api://api/merchants/employees/token/forgot"

    $http {method: "PUT", url: apiURL, data: requestBody}
    .success (data, status, headers, config) ->
       return data
    .error (data, status, headers, config) ->
      error = MessagingService.createMessage("error", data.message, 'ForgottenPassword')
      MessagingService.addMessage(error)
      MessagingService.hasMessages('ForgottenPassword')

  return Employees
]
