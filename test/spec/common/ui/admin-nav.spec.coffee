'use strict'

describe 'Directive: adminNav', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/partials/nav2.html'

  $scope = null
  $element = null
  Config = null
  Auth = null
  httpBackend = null

  beforeEach inject ($compile, $rootScope, $route, _Config_, _Auth_, versionCheckService, $httpBackend) ->
    Config = _Config_
    Auth = _Auth_
    httpBackend = $httpBackend

    $rootScope.unsecured = ['forgottenPassword', 'resetToken']

    httpBackend.whenGET('languages/en-GB/navigation.lang.json').respond("200")

    spyOn(Auth, 'isLoggedIn').andCallFake -> true

    # we don't care about this so just stub it out otherwise it starts making HTTP calls
    spyOn versionCheckService, 'startPolling'

    $scope = $rootScope.$new()
    $element = angular.element '<admin-nav></admin-nav>'
    $element = $compile($element) $scope

    $scope.$digest()

    $element.find('#menu').kendoMenu()

  describe 'in embedded mode', ->

    beforeEach ->
      spyOn(Config, 'mode').andCallFake -> 'embedded'
      $scope.$digest()

    it 'should not render the navbar', ->
      expect($element).toBeHidden()

  describe 'in browser mode', ->

    beforeEach ->
      spyOn(Config, 'mode').andCallFake -> 'browser'
      $scope.$digest()

    describe 'rendering', ->

      it 'should be visible', ->
        expect($element).not.toBeHidden()

      it 'should replace the element with a navbar', ->
        expect($element).toBeA 'nav'
        expect($element.find('#menu')).toHaveClass 'k-menu'

      it 'should create a home link', ->
        homeLink = $element.find('.navbar-brand:first')

        expect(homeLink.length).toBe 1
        expect(homeLink.attr('href')).toBe '#'
        expect(homeLink.text()).toBe 'myCircle'

    describe 'selective display of nav links', ->

      describe 'for a merchant user', ->

        beforeEach ->
          spyOn(Auth, 'hasRole').andCallFake (permission) ->
            permission is 'PERM_MERCHANT_API'
          $scope.$root.$broadcast 'auth:updated'

        it 'should show links that are available to anyone', ->
          expect($element.find('#menu a[href="#/employees"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/products"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/discounts"]').parent()).not.toBeHidden()

        it 'should hide links only available to platform admins', ->
          expect($element.find('#menu a[href="#/merchants"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/orders"]').parent()).toBeHidden()

        it 'should hide links only available to merchant admins', ->
          expect($element.find('#menu a[href="#/social"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/timesheets"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/tools"]').parent()).toBeHidden()

      describe 'for a merchant administrator', ->

        beforeEach ->
          spyOn(Auth, 'hasRole').andCallFake (permission) ->
            permission is 'PERM_MERCHANT_ADMINISTRATOR'
          $scope.$root.$broadcast 'auth:updated'

        it 'should show links that are available to anyone', ->
          expect($element.find('#menu a[href="#/employees"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/products"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/discounts"]').parent()).not.toBeHidden()

        it 'should hide links only available to platform admins', ->
          expect($element.find('#menu a[href="#/merchants"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/orders"]').parent()).toBeHidden()

        it 'should show links only available to merchant admins', ->
          expect($element.find('#menu a[href="#/social"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/timesheets"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/tools"]').parent()).not.toBeHidden()

      describe 'for a system administrator', ->

        beforeEach ->
          spyOn(Auth, 'hasRole').andCallFake (permission) ->
            permission is 'PERM_PLATFORM_ADMINISTRATOR'
          $scope.$root.$broadcast 'auth:updated'

        it 'should show links that are available to anyone', ->
          expect($element.find('#menu a[href="#/employees"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/products"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/discounts"]').parent()).not.toBeHidden()

        it 'should show links only available to platform admins', ->
          expect($element.find('#menu a[href="#/merchants"]').parent()).not.toBeHidden()
          expect($element.find('#menu a[href="#/orders"]').parent()).not.toBeHidden()

        it 'should hide links only available to merchant admins', ->
          expect($element.find('#menu a[href="#/social"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/timesheets"]').parent()).toBeHidden()
          expect($element.find('#menu a[href="#/tools"]').parent()).toBeHidden()

      describe 'for a merchant with no POPP smart tool', ->

        beforeEach ->
          spyOn(Auth, 'hasTool').andCallFake (toolId) -> false
          $scope.$root.$broadcast 'auth:updated'

        it 'should hide links only relevant to POPP enabled merchants', ->
          expect($element.find('#menu a[href="#/reports/sold-stock"]').parent()).toBeHidden()

      describe 'for a merchant with the POPP smart tool', ->

        beforeEach ->
          spyOn(Auth, 'hasTool').andCallFake (toolId) -> toolId is 'com.mycircleinc.smarttools.popp'
          $scope.$root.$broadcast 'auth:updated'

        it 'should hide links only relevant to POPP enabled merchants', ->
          expect($element.find('#menu a[href="#/reports/sold-stock"]').parent()).not.toBeHidden()

    describe 'responding to a route change', ->

      describe 'when the new route is in the nav', ->

        routes = null

        beforeEach inject ($location) ->
          routes = ['/employees', '/venues']

          spyOn($location, 'path').andCallFake ->
            routes.pop()

          $scope.$broadcast '$routeChangeSuccess'
          $scope.$digest()

        describe 'when the route changes again', ->

          beforeEach ->
            $scope.$broadcast '$routeChangeSuccess'
            $scope.$digest()

      describe 'when the new route is not in the nav', ->

        beforeEach inject ($location) ->
          spyOn($location, 'path').andCallFake ->
            '/foo'

          $scope.$broadcast '$routeChangeSuccess'
          $scope.$digest()

        it 'should not highlight the relevant nav link', ->
          expect($element.find('.k-state-active')).not.toExist()
