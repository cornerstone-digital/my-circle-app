'use strict'

angular.module('smartRegisterApp')
  .directive('adminNav', ['$rootScope', '$location', '$timeout', 'Config', 'Auth', ($rootScope, $location, $timeout, Config, Auth) ->
    replace: true
    restrict: 'E'
    scope: true
    templateUrl: 'views/partials/nav2.html'
    link: ($scope, $element) ->
      $scope.$on '$routeChangeStart', ->
        $element.find('li.k-state-active, li.k-state-hover').removeClass('k-state-active').removeClass('k-state-hover')

      $scope.$on '$routeChangeSuccess', ->
        $element.find("a[href='##{$location.path()}']").closest('li.toplevel').addClass('k-state-active')

      $scope.$watch 'isVisible()', (visible) ->
        $('body').toggleClass('has-navbar', visible)

      $scope.isLoggedIn = ->
        Auth.isLoggedIn() and Config.mode() is 'browser'

      $scope.isPreOrderEnabled = ->
        Auth.isPreOrderEnabled()

      $scope.isVisible = ->
        Config.mode() is 'browser'

      if $rootScope.isMobile() and !$rootScope.isMobile().tablet
        $("body").addClass('mobile').removeClass('browser')

        $("#menu").kendoMobileDrawer({
          container: "#content-wrapper"
        })
      else
        $("body").removeClass('mobile').addClass('browser')
        $("#menu").kendoMenu({
            alignToAnchor: true
            openOnClick: true
            select: (e) ->
              item = angular.element(e.item)
              link = item.find('a')
              hasNestedNav = item.hasClass("has-nested")
              topLevelItem = item.closest('li.toplevel')

              if !hasNestedNav
                $("#menu").data("kendoMenu").close(topLevelItem)

              if link.href?
                $location.path link.href
                $location.reload()

          }
        )

      $timeout ->
        if Auth.hasRole('PERM_PLATFORM_ADMINISTRATOR')
          merchantLink = $element.find("a[href='#/merchant']")
          merchantLink.remove()
        else
          merchantLink = $element.find("a[href='#/merchants']")
          merchantLink.remove()

        $("#drawer-trigger").click( ->
          drawer = $("#menu").data("kendoMobileDrawer")

          if drawer.visible
            drawer.hide()
          else
            drawer.show()

          return false
        )
      , 500
  ])
