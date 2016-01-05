'use strict'

angular.module('smartRegisterApp')
  .run ['$rootScope', '$location', '$route', '$timeout', '$window', 'Config', 'Auth','editableOptions', ($rootScope, $location, $route, $timeout, $window, Config, Auth, editableOptions) ->
    $rootScope.messages = []
    $rootScope.showMessages = false

    $rootScope.online = navigator.onLine
    $rootScope.posVersion = $location.search()['pos.version'] if $location.search()['pos.version']?

    $window.addEventListener "offline", (->
      $rootScope.$apply ->
        $rootScope.online = false
        return

      return
    ), false

    $window.addEventListener "online", (->
      $rootScope.$apply ->
        $rootScope.online = true
        return

      return
    ), false

    $rootScope.$on '$routeChangeStart', (event, currRoute, prevRoute) ->
      $rootScope.secured = currRoute.$$route?.secured
      $rootScope.route = currRoute

      if currRoute.$$route?.secured and !Auth.isLoggedIn()
        $location.path '/login'
      else if Auth.isLoggedIn() and currRoute.$$route?.role? and !Auth.hasRole(currRoute.$$route?.role) and $rootScope.mode == 'browser'
        $location.path '/forbidden'

    $rootScope.$on '$routeChangeSuccess', (event, route) ->
      $rootScope.messages = []
      $rootScope.showMessages = false
      $rootScope.overwriteBackUrl = false

      $rootScope.title = route.$$route?.title

      if route.$$route?.backUrl?
        $rootScope.backUrl = route.$$route?.backUrl


    $rootScope.back = (backUrl) ->
      if backUrl
        $rootScope.backUrl = backUrl

      $timeout ->
        window.location.href = '#' + $rootScope.backUrl
#        location.reload()
      ,100

    $rootScope.mode = Config.mode()
    $rootScope.iOSDevice = !!navigator.platform.match(/iPhone|iPod|iPad/);

    $rootScope.supportedInfo = kendo.support

    $rootScope.isTablet = ->
      $rootScope.supportedInfo.mobileOS && $rootScope.supportedInfo.mobileOS.tablet

    $rootScope.isMobile = ->
      $rootScope.supportedInfo.mobileOS


    $rootScope.crudServiceBaseUrl = "api://api"

    editableOptions.theme = 'bs3' # bootstrap3 theme. Can be also 'bs2', 'default'

    Auth.init()
    if $rootScope.credentials?.venue?.locale
      $rootScope.credentials.venue.locale = $rootScope.credentials?.venue?.locale.replace('_', "-")

    userLocale = $location.search()["locale"] || $rootScope.credentials?.venue?.locale || $window.navigator.userLanguage || $window.navigator.language

    Auth.setLocale(userLocale)

    $rootScope.$localeService = Auth.getLocaleService()

    OAuth.initialize 'mlUjjtrYAO4sT4G08XkeIzX0oZA'
    OAuth.callback 'foursquare', (err, result) ->
      if angular.isDefined result
        $location.path "/oauth/foursquare/#{result.access_token}"
    OAuth.callback 'facebook', (err, result) ->
      if angular.isDefined result
        $location.path "/oauth/facebook/#{result.access_token}"

    if Modernizr?.touch
      $ ->
        FastClick.attach document.body
  ]
  .value('localeConf', {
    basePath: 'languages'
    defaultLocale: 'en-GB'
    sharedDictionary: 'common'
    fileExtension: '.lang.json'
    persistSelection: false
    cookieName: 'COOKIE_LOCALE_LANG'
    observableAttrs: new RegExp('^data-(?!ng-|i18n)')
    delimiter: '::'
  })
  .value('localeSupported', [
      'en-GB'
      'es-ES'
  ])
  .value('localeFallbacks', {
      'en': 'en-GB'
      'es': 'es-ES'
  })
