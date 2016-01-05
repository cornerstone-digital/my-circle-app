(function() {
  'use strict';
  angular.module('smartRegisterApp').run([
    '$rootScope', '$location', '$route', '$timeout', '$window', 'Config', 'Auth', 'editableOptions', function($rootScope, $location, $route, $timeout, $window, Config, Auth, editableOptions) {
      var userLocale, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
      $rootScope.messages = [];
      $rootScope.showMessages = false;
      $rootScope.online = navigator.onLine;
      if ($location.search()['pos.version'] != null) {
        $rootScope.posVersion = $location.search()['pos.version'];
      }
      $window.addEventListener("offline", (function() {
        $rootScope.$apply(function() {
          $rootScope.online = false;
        });
      }), false);
      $window.addEventListener("online", (function() {
        $rootScope.$apply(function() {
          $rootScope.online = true;
        });
      }), false);
      $rootScope.$on('$routeChangeStart', function(event, currRoute, prevRoute) {
        var _ref, _ref1, _ref2, _ref3;
        $rootScope.secured = (_ref = currRoute.$$route) != null ? _ref.secured : void 0;
        $rootScope.route = currRoute;
        if (((_ref1 = currRoute.$$route) != null ? _ref1.secured : void 0) && !Auth.isLoggedIn()) {
          return $location.path('/login');
        } else if (Auth.isLoggedIn() && (((_ref2 = currRoute.$$route) != null ? _ref2.role : void 0) != null) && !Auth.hasRole((_ref3 = currRoute.$$route) != null ? _ref3.role : void 0) && $rootScope.mode === 'browser') {
          return $location.path('/forbidden');
        }
      });
      $rootScope.$on('$routeChangeSuccess', function(event, route) {
        var _ref, _ref1, _ref2;
        $rootScope.messages = [];
        $rootScope.showMessages = false;
        $rootScope.overwriteBackUrl = false;
        $rootScope.title = (_ref = route.$$route) != null ? _ref.title : void 0;
        if (((_ref1 = route.$$route) != null ? _ref1.backUrl : void 0) != null) {
          return $rootScope.backUrl = (_ref2 = route.$$route) != null ? _ref2.backUrl : void 0;
        }
      });
      $rootScope.back = function(backUrl) {
        if (backUrl) {
          $rootScope.backUrl = backUrl;
        }
        return $timeout(function() {
          return window.location.href = '#' + $rootScope.backUrl;
        }, 100);
      };
      $rootScope.mode = Config.mode();
      $rootScope.iOSDevice = !!navigator.platform.match(/iPhone|iPod|iPad/);
      $rootScope.supportedInfo = kendo.support;
      $rootScope.isTablet = function() {
        return $rootScope.supportedInfo.mobileOS && $rootScope.supportedInfo.mobileOS.tablet;
      };
      $rootScope.isMobile = function() {
        return $rootScope.supportedInfo.mobileOS;
      };
      $rootScope.crudServiceBaseUrl = "api://api";
      editableOptions.theme = 'bs3';
      Auth.init();
      if ((_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.locale : void 0 : void 0) {
        $rootScope.credentials.venue.locale = (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.venue) != null ? _ref3.locale.replace('_', "-") : void 0 : void 0;
      }
      userLocale = $location.search()["locale"] || ((_ref4 = $rootScope.credentials) != null ? (_ref5 = _ref4.venue) != null ? _ref5.locale : void 0 : void 0) || $window.navigator.userLanguage || $window.navigator.language;
      Auth.setLocale(userLocale);
      $rootScope.$localeService = Auth.getLocaleService();
      OAuth.initialize('mlUjjtrYAO4sT4G08XkeIzX0oZA');
      OAuth.callback('foursquare', function(err, result) {
        if (angular.isDefined(result)) {
          return $location.path("/oauth/foursquare/" + result.access_token);
        }
      });
      OAuth.callback('facebook', function(err, result) {
        if (angular.isDefined(result)) {
          return $location.path("/oauth/facebook/" + result.access_token);
        }
      });
      if (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.touch : void 0) {
        return $(function() {
          return FastClick.attach(document.body);
        });
      }
    }
  ]).value('localeConf', {
    basePath: 'languages',
    defaultLocale: 'en-GB',
    sharedDictionary: 'common',
    fileExtension: '.lang.json',
    persistSelection: false,
    cookieName: 'COOKIE_LOCALE_LANG',
    observableAttrs: new RegExp('^data-(?!ng-|i18n)'),
    delimiter: '::'
  }).value('localeSupported', ['en-GB', 'es-ES']).value('localeFallbacks', {
    'en': 'en-GB',
    'es': 'es-ES'
  });

}).call(this);

//# sourceMappingURL=bootstrap.js.map
