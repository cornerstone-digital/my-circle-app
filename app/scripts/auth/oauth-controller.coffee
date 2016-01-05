'use strict'

angular.module('smartRegisterApp')
  .controller 'OAuthCtrl', ['$routeParams', '$location', 'Tool', 'tools', ($routeParams, $location, Tool, tools) ->
    provider = $routeParams.provider
    token = $routeParams.token
    appId = "com.mycircleinc.smarttools.social.#{provider}"

    tool = _.find tools, (it) -> it.appId is appId

    successCallback = ->
      $location.path '/social'

    if tool?
      tool.properties = {} unless tool.properties?
      tool.properties.token = token
      tool.$update successCallback
    else
      tool = new Tool
        appId: appId
        availableTo: [0..3]
        displayIndex: 5
        properties:
          token: token
      tool.$save successCallback
  ]
