'use strict'

angular.module('smartRegisterApp')
.factory 'Employee', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
  Employee = $resource "api://api/merchants/:merchantId/employees/:id",
    id: "@id"
    # there's a circular dependency if Auth is injected here as Auth queries venues
    merchantId: -> Auth.getMerchant()?.id
  ,
    save:
      method: 'POST'
      transformRequest: (requestBody) ->
        data = angular.copy(requestBody)
        delete data.credentials
        JSON.stringify(data)
    update:
      method: 'PUT'
      transformRequest: (requestBody) ->
        data = angular.copy(requestBody)
        delete data.credentials
        delete data.discounts
        delete data.smartTools
        JSON.stringify(data)

  Employee::isInGroup = (groupName) ->
    _.findWhere(@groups, name: groupName)?

  Employee
]
