'use strict'

###
Service for authenticating users and verifying they are logged in.
###
angular.module('smartRegisterApp')
  .factory 'Auth', ['$http', '$rootScope', '$location', '$timeout', 'Config', 'Venue', 'ResourceNoPaging', 'locale', ($http, $rootScope, $location, $timeout, Config, Venue, ResourceNoPaging, locale) ->

    ###
    The object that holds information about the logged in user
    ###
    $rootScope.credentials = null
    $rootScope.unsecured = ['forgottenPassword', 'resetToken']

    $rootScope.$watch 'credentials', (value) ->
      if value?
        localStorage.setItem 'credentials', JSON.stringify value
      else
        localStorage.removeItem 'credentials'

      $rootScope.$broadcast 'auth:updated'
    , true

    storeVenueDetails = (venue) ->
      $rootScope.credentials.venue = venue
      $rootScope.credentials.tools = []
      _.each venue.smartTools, (tool) ->
        $rootScope.credentials.tools.push tool.appId if tool.groups.length > 0

    ###
    Is a user logged in? This is determined by the presence of a credentials object in localStorage.
    ###
    isLoggedIn: ->
      $rootScope.credentials?

    isSecured: ->
      !$rootScope.unsecured.indexOf($location.$$path)

    isMemberOf: (groupName) ->
      groups = $rootScope.credentials?.groups ? []
      groupName in groups

    hasRole: (permission) ->
      permissions = $rootScope.credentials?.permissions ? []

      permission in permissions or 'PERM_DEVELOPER' in permissions

    hasTool: (toolId) ->
      tools = $rootScope.credentials?.tools ? []
      toolId in tools

    ###
    Log in via the /authenticate endpoint in the API.
    ###
    login: (user, successCallback, errorCallback) ->
      # base64 encode the credentials
      authHeader = btoa("#{user.email}:#{user.password}")
      $http.get "api://api/merchants/authenticate",
        headers:
          Authorization: "Basic #{authHeader}"
      .success (data) =>
        $rootScope.credentials =
          username: data.employee.displayName
          email: user.email
          token: data.sessionId
          merchant:
            id: data.merchantId
          permissions: _.flatten data.employee.groups?.map (group) ->
            permissions = group.authorities?.map (it) ->
              it.permission
            permissions ? []
          groups: _.pluck data.employee.groups, 'name'
        $timeout ->
          ResourceNoPaging.one("merchants", data.merchantId).getList("venues", {full:false}).then((venues) ->
            if venues.length
              storeVenueDetails venues[0]
              $rootScope.credentials.venues = venues
              successCallback $rootScope.credentials
            else
              $rootScope.credentials = null
              errorCallback 'Merchant has no venues'
          )

          permissions = $rootScope.credentials?.permissions ? []
          if 'PERM_PLATFORM_ADMINISTRATOR' in permissions or 'PERM_DEVELOPER' in permissions
            ResourceNoPaging.all("merchants").all("list").getList().then((merchants) ->
              if merchants.length
                $rootScope.merchants = merchants
              else
                $rootScope.credentials = null
                errorCallback 'Merchant has no venues'
            )


      .error (data, status) ->
        errorCallback if status is 401 then 'Incorrect username or password' else 'Login failed'

    logout: ->
      $http.get "api://api/merchants/logout"
        .success ->
          $rootScope.credentials = null
          $location.path '/login'
        .error ->
          # If any error from the backend, just assume the worst and log them out anyway.
          $rootScope.credentials = null
          $location.path '/login'


    getVenue: ->
      $rootScope.credentials?.venue

    getMerchant: ->
      $rootScope.credentials?.merchant

    getCredentials: ->
      $rootScope.credentials

    clearCredentials: ->
      $rootScope.credentials = null

    impersonateMerchant: (merchant, callback) ->
      $rootScope.credentials.merchant = merchant
      ResourceNoPaging.one("merchants", merchant.id).getList("venues", {full:false}).then((venues) ->
        if venues.length
          $rootScope.credentials.venues = venues
          $rootScope.$broadcast 'merchant:switch', venues[0]
          storeVenueDetails venues[0]
          callback()
        else
          $rootScope.credentials = null
          errorCallback 'Merchant has no venues'
      )

    switchVenue: (venue, callback) ->
      storeVenueDetails venue
      callback()

    setLocale: (localeStr) ->
      locale.setLocale(localeStr)

    getLocale: ->
      locale.getLocale()

    getLocaleService: ->
      locale

    ###
    Initializes authentication state based on `token` and `venueId` query string params
    or local storage values.
    ###
    init: ->
      token = $location.search().token
      merchantId = $location.search().merchantId
      venueId = $location.search().venueId
      email = $location.search().email


      # if all provided on qs use them
      if email? and token? and merchantId? and venueId?
        $rootScope.credentials =
          email: email
          token: token
          merchant:
            id: merchantId
          venue:
            id: venueId

      # if any are missing from qs clear any existing credentials – user must revalidate
      else if email? or token? or merchantId? or venueId?
        @clearCredentials()

      # if none are on qs then use any stored credentials
      else
        $rootScope.credentials = JSON.parse localStorage.getItem('credentials')

      # if we have no valid credentials redirect to login
      if !@isLoggedIn() and $rootScope.secured
        $location.path '/login'
  ]

