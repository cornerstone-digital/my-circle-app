'use strict'

angular.module('API', [
  'restangular'
])
.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "api://api"
  return

angular.module('API').factory 'ResourceWithPaging', ['Restangular', (Restangular) ->
  resource = Restangular.withConfig((RestangularProvider) ->
    RestangularProvider.setResponseExtractor (response, operation) ->
      if operation == "getList"
        newResponse = response.content ? []
        newResponse.page = response.page ? {}
        newResponse.links = response.links ? {}

        return newResponse
      else
        return response
  )

  return resource
]

angular.module('API').factory 'ResourceNoPaging', ['$rootScope', 'Restangular', ($rootScope, Restangular) ->

  resource = Restangular.withConfig((RestangularProvider) ->
    RestangularProvider.setResponseExtractor (response, operation) ->
      if operation == "getList"
        if angular.isObject response
          newResponse = []
          angular.forEach response, (value, index) ->
            newResponse.push value

          return newResponse

        return response
      else
        return response
  )

  return resource
]