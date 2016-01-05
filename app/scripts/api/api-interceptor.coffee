'use strict'

angular.module('smartRegisterApp')
.factory 'apiInterceptor', ['$q', '$rootScope', '$location', '$timeout', '$filter', 'Config', 'MessagingService', ($q, $rootScope, $location, $timeout, $filter, Config, MessagingService) ->

  # This adds authorization headers to outgoing requests to the myCircle
  # API. Other requests are not affected to avoid forcing them to use
  # CORS pre-flighting.
  request: (config) ->
    MessagingService.resetMessages()

    if config.url.indexOf('api:/') is 0
      config.url = config.url.replace(/^api:\//, Config.baseURL())
      config.isApiCall = true # allows us to detect an API call in the response interceptor without sniffing baseURL

      credentials = JSON.parse localStorage.getItem('credentials')

      if credentials?.token? and not config.headers['Authorization']?
        hash = $filter('hmacSha256') "#{credentials.token}:#{credentials.email}", credentials.token

        config.headers['Authorization'] = "Token #{hash}"
        config.headers['X-Session-Id'] = credentials.token

    config.headers = {} unless config.headers
    config.headers['X-Merchant-Dashboard-Version'] = $rootScope.currentVersion

    config

  # This intercepts any failed service calls and redirects to the login page if
  # the failure was caused by a 401. Other errors are handled by rejecting the
  # promise. This means we don't need any error handling on specific service calls
  # as it's all dealt with here.
  responseError: (response) ->

    if response.config.isApiCall
      switch
        when response.status is 401
          $rootScope.retryPath = $location.path()
          # Invalidate the user's credentials otherwise LoginCtrl will bounce
          # them right back here & we'll get a lovely infinite redirect loop.
          # Can't use Auth.logout() here as it creates a circular dependency
          $rootScope.credentials = null
          $location.path '/login'
#        when response.status is 403
#          $location.path '/forbidden'
        when response.status in [500..599]
          $rootScope.$broadcast 'apiConnectionError'
        when response.status is 0
#          $rootScope.$broadcast 'apiUnreachable'
#          if $rootScope.credentials?
#            $timeout ->
#              MessagingService.resetMessages()
#              error = {
#                status: response.status
#                message: "Connection Error: Please check your internet connection and then refresh your page."
#              }
#
#              errorMsg = MessagingService.createMessage('error', error.message, 'GlobalErrors')
#              MessagingService.addMessage(errorMsg)
#
#              MessagingService.hasMessages('GlobalErrors')
#            , 500
#          console.log response
        else
          $rootScope.errors = response.data?.errors ? []
          if $rootScope.errors?



            angular.forEach $rootScope.errors, (value, index) ->
              error = $rootScope.errors[index]

              if angular.isArray error
                message = error[0]
                console.log message

              errorMsg = MessagingService.createMessage('error', message, 'GlobalErrors')
              MessagingService.addMessage(errorMsg)

            if response.data?.message?
              MessagingService.resetMessages()
              errorMsg = MessagingService.createMessage('error', response.data.message + " Error Reference: " + response.data.reference, 'GlobalErrors')
              MessagingService.addMessage(errorMsg)

          MessagingService.hasMessages('GlobalErrors')

          console.error "Got error #{response.status}", response.config.method, response.config.url
    $q.reject response
]
