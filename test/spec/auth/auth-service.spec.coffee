'use strict'

describe 'Service: Auth', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  Config = null
  Auth = null
  Venue = null
  $rootScope = null
  $httpBackend = null

  credentials = null

  beforeEach inject (_Config_, _Auth_, _Venue_, _$rootScope_, $injector) ->
    Config = _Config_
    Auth = _Auth_
    Venue = _Venue_
    $rootScope = _$rootScope_
    $httpBackend = $injector.get('$httpBackend')

    $httpBackend.whenGET('views/login.html').respond("200")
    $httpBackend.whenGET('views/faq.html').respond("200")
    $httpBackend.whenGET('views/404.html').respond("200")

    credentials =
      username: 'Al'
      email: 'al.coholic@mycircleinc.com'
      merchant:
        id: 'the-merchant-id'
      token: 'the-session-token'
      venue:
        new Venue
          id: 'the-venue-id'
          name: 'The Electric Psychedelic Pussycat Swingers Club'
          smartTools: [
            appId: 'com.mycircleinc.smarttools.register'
            groups: [
              id: 70
              name: 'MERCHANT_EMPLOYEES'
            ]
          ]
      permissions: [
        'PERM_MERCHANT_API'
        'PERM_MERCHANT_ADMINISTRATOR'
        'PERM_VENUE_ADMINISTRATOR'
      ]

  afterEach ->
    localStorage.clear()

  describe 'when no user is logged in', ->

    it 'should return false from isLoggedIn', ->
      expect(Auth.isLoggedIn()).toBe false

    it 'should return null from getCredentials', ->
      expect(Auth.getCredentials()).toBeNull()

    it 'should return undefined from getVenue', ->
      expect(Auth.getVenue()).toBeUndefined()

    for permission in ['PERM_MERCHANT_API', 'PERM_MERCHANT_ADMINISTRATOR', 'PERM_VENUE_ADMINISTRATOR', 'PERM_PLATFORM_ADMINISTRATOR']
      ((permission) ->
        it "should return false from hasRole(#{permission})", ->
          expect(Auth.hasRole(permission)).toBe false
      ) permission

  describe 'when a user is logged in already', ->

    beforeEach ->
      $rootScope.$apply ->
        $rootScope.credentials = credentials

    it 'should return true from isLoggedIn', ->
      expect(Auth.isLoggedIn()).toBe true

    it 'should return the credentials object from getCredentials', ->
      expect(JSON.stringify Auth.getCredentials()).toEqual JSON.stringify credentials

    for permission in ['PERM_MERCHANT_API', 'PERM_MERCHANT_ADMINISTRATOR', 'PERM_VENUE_ADMINISTRATOR']
      ((permission) ->
        it "should return true from hasRole(#{permission})", ->
          expect(Auth.hasRole(permission)).toBe true
      ) permission

    for permission in ['PERM_PLATFORM_ADMINISTRATOR']
      ((permission) ->
        it "should return false from hasRole(#{permission})", ->
          expect(Auth.hasRole(permission)).toBe false
      ) permission

  describe 'when a superuser is logged in', ->

    beforeEach ->
      $rootScope.$apply ->
        $rootScope.credentials = credentials
        $rootScope.credentials.permissions = ['PERM_DEVELOPER']

    for permission in ['PERM_MERCHANT_API', 'PERM_MERCHANT_ADMINISTRATOR', 'PERM_VENUE_ADMINISTRATOR', 'PERM_PLATFORM_ADMINISTRATOR']
      ((permission) ->
        it "should return true from hasRole(#{permission})", ->
          expect(Auth.hasRole(permission)).toBe true
      ) permission

  describe 'tool availability', ->

    toolId = 'some.made.up.tool.id'

    describe 'when the merchant has a tool', ->

      beforeEach ->
        $rootScope.credentials =
          tools: [toolId]

      it 'should consider the tool to be available', ->
        expect(Auth.hasTool(toolId)).toBe true

    describe 'when the merchant does not have a tool', ->

      it 'should consider the tool to not be available', ->
        expect(Auth.hasTool(toolId)).toBe false

  describe 'initialization', ->

    $location = null
    currentPath = null

    beforeEach inject (_$location_) ->
      $location = _$location_

      currentPath = '/foo'
      $location.path currentPath

    describe 'when credentials already exist in local storage', ->
      beforeEach ->
        localStorage.setItem 'credentials', JSON.stringify credentials

      describe 'and no token is provided in the query string', ->
        beforeEach ->
          $rootScope.$apply -> Auth.init()

        it 'uses the existing credentials', ->
          expect(JSON.stringify(Auth.getCredentials())).toBe JSON.stringify credentials

      describe 'and only a token is provided in the query string', ->
        beforeEach ->
          $location.search 'token', 'a-different-token'
          $rootScope.$apply -> Auth.init()

        it 'clears the stored credentials', ->
          expect(Auth.getCredentials()).toBeNull()
          expect(localStorage.getItem('credentials')).toBeNull()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'and only a merchant id is provided in the query string', ->
        beforeEach ->
          $location.search 'merchantId', 'a-different-merchant'
          $rootScope.$apply -> Auth.init()

        it 'clears the stored credentials', ->
          expect(Auth.getCredentials()).toBeNull()
          expect(localStorage.getItem('credentials')).toBeNull()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'and only a venue id is provided in the query string', ->
        beforeEach ->
          $location.search 'venueId', 'a-different-venue'
          $rootScope.$apply -> Auth.init()

        it 'clears the stored credentials', ->
          expect(Auth.getCredentials()).toBeNull()
          expect(localStorage.getItem('credentials')).toBeNull()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'when email, token, merchant id and venue id are provided in the query string', ->

        beforeEach ->
          $location.search 'email', 'al.coholic@mycircleinc.com'
          $location.search 'token', 'a-different-token'
          $location.search 'merchantId', 'a-different-merchant'
          $location.search 'venueId', 'a-different-venue'

          $rootScope.$apply -> Auth.init()

        it 'creates a new credentials object', ->
          c = Auth.getCredentials()
          expect(c).not.toBeUndefined()
          expect(c).not.toBeNull()
          expect(c.email).toBe 'al.coholic@mycircleinc.com'
          expect(c.token).toBe 'a-different-token'

        it 'holds on to the merchant id', ->
          expect(Auth.getCredentials().merchant.id).toBe 'a-different-merchant'

        it 'holds on to the venue id', ->
          expect(Auth.getCredentials().venue.id).toBe 'a-different-venue'

#        it 'does not redirect anywhere', ->
#          expect($location.path()).toBe currentPath

        it 'persists the new credentials for future sessions', ->
          storedCredentials = JSON.parse localStorage.getItem('credentials')
          expect(storedCredentials).not.toBeNull()
          expect(storedCredentials.email).toBe 'al.coholic@mycircleinc.com'
          expect(storedCredentials.token).toBe 'a-different-token'
          expect(storedCredentials.merchant.id).toBe 'a-different-merchant'
          expect(storedCredentials.venue.id).toBe 'a-different-venue'

    describe 'when no credentials exist in local storage', ->

      describe 'and only a token is provided in the query string', ->
        beforeEach ->
          $location.search 'token', credentials.token
          $rootScope.$apply -> Auth.init()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'and only a merchant id is provided in the query string', ->
        beforeEach ->
          $location.search 'merchantId', credentials.merchantId
          $rootScope.$apply -> Auth.init()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'and only a venue id is provided in the query string', ->
        beforeEach ->
          $location.search 'venueId', credentials.venueId
          $rootScope.$apply -> Auth.init()

#        it 'redirects the user to the login page', ->
#          expect($location.path()).toBe '/login'
#          expect($rootScope.retryPath).toBe currentPath

      describe 'when email, token, merchant id and venue id are all provided in the query string', ->
        beforeEach ->
          $location.search 'email', credentials.email
          $location.search 'token', credentials.token
          $location.search 'merchantId', credentials.merchant.id
          $location.search 'venueId', credentials.venue.id

          $rootScope.$apply -> Auth.init()

        it 'creates a new credentials object', ->
          c = Auth.getCredentials()
          expect(c).not.toBeUndefined()
          expect(c).not.toBeNull()
          expect(c.email).toBe credentials.email
          expect(c.token).toBe credentials.token
          expect(c.merchant.id).toBe credentials.merchant.id
          expect(c.venue.id).toBe credentials.venue.id

#        it 'does not redirect anywhere', ->
#          expect($location.path()).toBe currentPath

        it 'persists the new credentials for future sessions', ->
          storedCredentials = JSON.parse localStorage.getItem('credentials')
          expect(storedCredentials).not.toBeNull()
          expect(storedCredentials.email).toBe credentials.email
          expect(storedCredentials.token).toBe credentials.token
          expect(storedCredentials.merchant.id).toBe credentials.merchant.id
          expect(storedCredentials.venue.id).toBe credentials.venue.id

  describe 'logging in', ->

    $timeout = null
    password = null
    basicAuthCheck = null
    successCallback = null
    failureCallback = null

    beforeEach inject (_$timeout_) ->
      $timeout = _$timeout_
      password = 'correct horse battery staple'

      basicAuthCheck = (headers) =>
        basicAuth = btoa("#{credentials.email}:#{password}")
        headers['Authorization'] is "Basic #{basicAuth}"

      successCallback = jasmine.createSpy()
      failureCallback = jasmine.createSpy()

    describe 'when login succeeds', ->

      venues = null

      beforeEach inject (Venue) ->
        # given the auth service will accept our login
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/authenticate", basicAuthCheck)
        .respond
          sessionId: credentials.token
          merchantId: credentials.merchant.id
          employee:
            id: 2
            version: 0
            firstname: "MyCircle"
            lastname: "Inc"
            email: "user@mycircleinc.com"
            locale: "en_GB"
            accountNonExpired: true
            accountNonLocked: true
            credentialsNonExpired: true
            enabled: true
            groups: [
              id: 40
              version: 0
              name: "PLATFORM_ADMINISTRATORS"
              authorities: [
                id: 50
                version: 0
                permission: "PERM_MERCHANT_ADMINISTRATOR"
                docType: "authority"
              ,
                id: 70
                version: 0
                permission: "PERM_MERCHANT_API"
                docType: "authority"
              ,
                id: 40
                version: 0
                permission: "PERM_PLATFORM_ADMINISTRATOR"
                docType: "authority"
              ,
                id: 60
                version: 0
                permission: "PERM_VENUE_ADMINISTRATOR"
                docType: "authority"
              ]
              docType: "group"
            ]
            apiVersion: "3.0.0"
            created: "2013-12-13T10:00:00Z"
            displayName: credentials.username
            name: "MyCircle Inc"
            docType: "employee"

        merchant =
          id: credentials.merchant.id
          venues: [
          ]

        venues = [
          name: 'The Electric Psychedelic Pussycat Swingers Club'
          smartTools: [
            appId: 'tool.with.no.auth'
            groups: []
          ,
            appId: 'tool.with.auth'
            groups: [
              id: 70
            ]
          ]
        ,
          name: 'The Gentleman Loser'
        ,
          name: 'The Slaughtered Lamb'
        ].map (it) -> new Venue(it)

        # when the user logs in
        Auth.login
            email: credentials.email
            password: password
          , successCallback, failureCallback

        $httpBackend.flush 1

        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{credentials.merchant.id}/venues?full=false").respond venues
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/list").respond {}

        $timeout.flush()
        $httpBackend.flush 1

      it 'stores the credentials', ->
        expect(Auth.getCredentials().email).toBe credentials.email
        expect(Auth.getCredentials().token).toBe credentials.token
        expect(Auth.getCredentials().merchant.id).toBe credentials.merchant.id
        for permission in ['PERM_MERCHANT_API', 'PERM_MERCHANT_ADMINISTRATOR', 'PERM_VENUE_ADMINISTRATOR', 'PERM_PLATFORM_ADMINISTRATOR']
          expect(permission in Auth.getCredentials().permissions).toBe true

#      it 'calls the success callback', ->
#        expect(successCallback).toHaveBeenCalled()
#        expect(failureCallback).not.toHaveBeenCalled()

#      it 'selects the first available venue', ->
#        expect(Auth.getVenue().name).toBe venues[0].name
#
#      it 'stores the ids of the smart tools available', ->
#        expect(Auth.getCredentials().tools).toEqual ['tool.with.auth']

    describe 'when login succeeds but merchant has no venues', ->

      beforeEach inject (Venue) ->
        # given the auth service will accept our login
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/authenticate", basicAuthCheck)
        .respond
          sessionId: credentials.token
          merchantId: credentials.merchant.id
          employee:
            displayName: credentials.username

        # when the user logs in
        Auth.login
            email: credentials.email
            password: password
          , successCallback, failureCallback

        $httpBackend.flush 1

        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{credentials.merchant.id}/venues?full=false").respond []
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/list").respond {}

        $timeout.flush()
        $httpBackend.flush 1

#      it 'does not store any credentials', ->
#        expect(Auth.getCredentials()).toBeNull()

#      it 'calls the failure callback', ->
#        expect(successCallback).not.toHaveBeenCalled()
#        expect(failureCallback).toHaveBeenCalledWith 'Merchant has no venues'

    describe 'when login succeeds but user has some blank authorities', ->

      venues = null

      beforeEach inject (Venue) ->
        # given the auth service will accept our login
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/authenticate", basicAuthCheck)
        .respond
          sessionId: credentials.token
          merchantId: credentials.merchant.id
          employee:
            id: 2
            version: 0
            firstname: "MyCircle"
            lastname: "Inc"
            email: "user@mycircleinc.com"
            locale: "en_GB"
            accountNonExpired: true
            accountNonLocked: true
            credentialsNonExpired: true
            enabled: true
            groups: [
              id: 200
              version: 0
              name: "DISCOUNTS"
              locked: true
              docType: "group"
            ,
              id: 40
              version: 0
              name: "PLATFORM_ADMINISTRATORS"
              locked: true
              authorities: [
                id: 50
                version: 0
                permission: "PERM_MERCHANT_ADMINISTRATOR"
                locked: true
                docType: "authority"
              ,
                id: 70
                version: 0
                permission: "PERM_MERCHANT_API"
                locked: true
                docType: "authority"
              ,
                id: 40
                version: 0
                permission: "PERM_PLATFORM_ADMINISTRATOR"
                locked: true
                docType: "authority"
              ,
                id: 60
                version: 0
                permission: "PERM_VENUE_ADMINISTRATOR"
                locked: true
                docType: "authority"
              ]
              docType: "group"
            ,
              id: 300
              version: 0
              name: "SMARTTOOLS"
              locked: true
              docType: "group"
            ]
            apiVersion: "3.0.0"
            created: "2013-12-13T10:00:00Z"
            displayName: "Default User"
            name: "MyCircle Inc"
            docType: "employee"

        venues = [
          new Venue
            name: 'The Electric Psychedelic Pussycat Swingers Club'
        ]

        # when the user logs in
        Auth.login
            email: credentials.email
            password: password
          , successCallback, failureCallback

        $httpBackend.flush 1

        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{credentials.merchant.id}/venues?full=false").respond venues
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/list").respond {}

        $timeout.flush()
        $httpBackend.flush 1

      it 'ignores the empty authorities', ->
        expect(Auth.getCredentials().permissions.length).toBe 4

    describe 'when login fails', ->
      beforeEach ->
        # given the auth service will reject our login
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/authenticate", basicAuthCheck)
        .respond 401

        # when the user logs in
        Auth.login
            email: credentials.email
            password: password
          , successCallback, failureCallback

        $httpBackend.flush()

      it 'does not store any credentials', ->
        expect(Auth.getCredentials()).toBeNull()

      it 'calls the failure callback', ->
        expect(successCallback).not.toHaveBeenCalled()
        expect(failureCallback).toHaveBeenCalledWith 'Incorrect username or password'

  describe 'merchant switching', ->

    beforeEach ->
      $rootScope.credentials =
        merchant:
          id: 'global-admin-id'

    describe 'when a global admin switches merchant', ->

      callback = null

      beforeEach inject (Config, $httpBackend) ->
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/a-merchant-id/venues?full=false").respond 200, [
          id: 'a-venue-id'
          smartTools: [
            appId: 'tool1'
            groups: []
          ,
            appId: 'tool2'
            groups: [
              id: 70
            ]
          ,
            appId: 'tool3'
            groups: [
              id: 70
            ]
          ]
        ,
          id: 'another-venue-id'
        ]

        callback = jasmine.createSpy()

        $rootScope.$apply ->
          Auth.impersonateMerchant
            id: 'a-merchant-id'
          , callback

        $httpBackend.flush()

      it 'should store the impersonated merchant', ->
        expect(Auth.getCredentials().merchant.id).toBe 'a-merchant-id'

      it 'should store the impersonated venue', ->
        expect(Auth.getCredentials().venue.id).toBe 'a-venue-id'

      it 'should store the list of smart tools available to the impersonated venue', ->
        expect(Auth.getCredentials().tools).toEqual ['tool2', 'tool3']

      it 'should use the impersonated merchant', ->
        expect(Auth.getMerchant().id).toBe 'a-merchant-id'

      it 'should use the impersonated venue', ->
        expect(Auth.getVenue().id).toBe 'a-venue-id'