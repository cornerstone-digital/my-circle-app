(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('adminNav', [
    '$rootScope', '$location', '$timeout', 'Config', 'Auth', function($rootScope, $location, $timeout, Config, Auth) {
      return {
        replace: true,
        restrict: 'E',
        scope: true,
        templateUrl: 'views/partials/nav2.html',
        link: function($scope, $element) {
          $scope.$on('$routeChangeStart', function() {
            return $element.find('li.k-state-active, li.k-state-hover').removeClass('k-state-active').removeClass('k-state-hover');
          });
          $scope.$on('$routeChangeSuccess', function() {
            return $element.find("a[href='#" + ($location.path()) + "']").closest('li.toplevel').addClass('k-state-active');
          });
          $scope.$watch('isVisible()', function(visible) {
            return $('body').toggleClass('has-navbar', visible);
          });
          $scope.isLoggedIn = function() {
            return Auth.isLoggedIn() && Config.mode() === 'browser';
          };
          $scope.isPreOrderEnabled = function() {
            return Auth.isPreOrderEnabled();
          };
          $scope.isVisible = function() {
            return Config.mode() === 'browser';
          };
          if ($rootScope.isMobile() && !$rootScope.isMobile().tablet) {
            $("body").addClass('mobile').removeClass('browser');
            $("#menu").kendoMobileDrawer({
              container: "#content-wrapper"
            });
          } else {
            $("body").removeClass('mobile').addClass('browser');
            $("#menu").kendoMenu({
              alignToAnchor: true,
              openOnClick: true,
              select: function(e) {
                var hasNestedNav, item, link, topLevelItem;
                item = angular.element(e.item);
                link = item.find('a');
                hasNestedNav = item.hasClass("has-nested");
                topLevelItem = item.closest('li.toplevel');
                if (!hasNestedNav) {
                  $("#menu").data("kendoMenu").close(topLevelItem);
                }
                if (link.href != null) {
                  $location.path(link.href);
                  return $location.reload();
                }
              }
            });
          }
          return $timeout(function() {
            var merchantLink;
            if (Auth.hasRole('PERM_PLATFORM_ADMINISTRATOR')) {
              merchantLink = $element.find("a[href='#/merchant']");
              merchantLink.remove();
            } else {
              merchantLink = $element.find("a[href='#/merchants']");
              merchantLink.remove();
            }
            return $("#drawer-trigger").click(function() {
              var drawer;
              drawer = $("#menu").data("kendoMobileDrawer");
              if (drawer.visible) {
                drawer.hide();
              } else {
                drawer.show();
              }
              return false;
            });
          }, 500);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=admin-nav.js.map
