'use strict'

angular.module('versionPoll')
  .constant('frequencySeconds', 5*60)
  .factory 'versionCheckService', ['$rootScope', '$http', '$timeout', 'frequencySeconds', 'POSService', ($rootScope, $http, $timeout, frequencySeconds, POSService) ->
    currentVersion = null
    lastModified = null
    serverInformation = null
    gitHash = null
    pollDashboardVersion = ->
      requestHeaders = {}
      requestHeaders['If-Modified-Since'] = lastModified if lastModified?
      $http.get '/version.txt',
        headers: requestHeaders
      .success (newVersion, status, responseHeaders) ->
        if currentVersion?
          if currentVersion is newVersion
            $timeout pollDashboardVersion, frequencySeconds * 1000
          else
            currentVersion = newVersion
            lastModified = responseHeaders('Last-Modified')
            $rootScope.$broadcast 'version:changed', newVersion
        else
          currentVersion = newVersion
          $rootScope.currentVersion = currentVersion
          lastModified = responseHeaders('Last-Modified')
          $timeout pollDashboardVersion, frequencySeconds * 1000
      .error (data, status) ->
        if status is 304
          $timeout pollDashboardVersion, frequencySeconds * 1000
        else
          console.warn 'Version check got an error', status, data

    pollGitHashVersion = ->
      requestHeaders = {}
      requestHeaders['If-Modified-Since'] = lastModified if lastModified?
      $http.get '/git-version.txt',
        headers: requestHeaders
      .success (newGitHash, status, responseHeaders) ->

        if gitHash?
          if gitHash is newGitHash
            $timeout pollGitHashVersion, frequencySeconds * 1000
          else
            gitHash = newGitHash
            lastModified = responseHeaders('Last-Modified')
            $rootScope.$broadcast 'version:changed', newGitHash
        else
          gitHash= newGitHash
          lastModified = responseHeaders('Last-Modified')
          $timeout pollGitHashVersion, frequencySeconds * 1000
      .error (data, status) ->
        if status is 304
          $timeout pollGitHashVersion, frequencySeconds * 1000
        else
          console.warn 'Git version check got an error', status, data

    checkPOSVersion = (serverInformation) ->
      if $rootScope.posVersion?
        if serverInformation?.latestPosVersion > $rootScope.posVersion
          $rootScope.$broadcast 'posversion:changed', serverInformation

    pollServerVersion = ->
      $http.get("api://api/information").success (response) ->
        serverInformation = response
        $timeout pollServerVersion, frequencySeconds * 1000

        checkPOSVersion(serverInformation)

    compareVersions = (versionOne, versionTwo) ->
      versionOneArr = versionOne.split('.')
      versionTwoArr = versionTwo.split('.')

      versionDiff = false

      # Compare major
      if(versionOneArr[0] != versionTwoArr[0])
        versionDiff = true

      # Compare minor
      if(versionOneArr[1] != versionTwoArr[1])
        versionDiff = true

      # Compare patch
      if(versionOneArr[2] != versionTwoArr[2])
        versionDiff = true

      return versionDiff



#    normalisedVersion = (version) ->
#      splitArr = version.split('.')
#      concatStr = ""
#
#      angular.forEach splitArr, (value,index) ->
#        concatStr = concatStr + value
#
#      retrun concatStr


    startPolling: ->
      pollDashboardVersion()
      pollGitHashVersion()
      pollServerVersion()
#      @checkPOSVersions()

    currentVersion: ->
      currentVersion

    checkPOSVersions: (POSList) ->

      if !POSList?
        POSService.getList().then((posList) ->
          POSList = posList
        )

      $timeout ->
        $http.get("api://api/information").success (response) ->
          serverInformation = response
          versionDiff = false

          angular.forEach POSList, (value, index) ->

            if compareVersions(serverInformation?.latestPosVersion, value.posVersion)
              versionDiff = true

          console.log versionDiff

          if versionDiff
            message = "Version #{serverInformation.latestPosVersion} of the iOS App is now available. Some of your POS may be running an older version, please update as soon as possible."

            toastr.options = {
              "closeButton": true,
              "debug": false,
              "positionClass": "toast-top-full-width",
              "onclick": null,
              "showDuration": "1000",
              "hideDuration": "1000",
              "timeOut": "0",
              "extendedTimeOut": "1000",
              "showEasing": "swing",
              "hideEasing": "linear",
              "showMethod": "fadeIn",
              "hideMethod": "fadeOut"
            }

            toastr.info(message)
        , 500

    getHash: ->
      gitHash

    lastModified: ->
      lastModified

    serverInformation: ->
      serverInformation
  ]
