(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('ValidationService', [
    '$rootScope', 'MessagingService', function($rootScope, MessagingService) {
      return {
        validate: function(group) {
          return $rootScope.$broadcast('validate-data:validate', group);
        },
        reset: function() {
          return $rootScope.$broadcast('validate-data:reset');
        },
        isRequired: function(value) {
          value = String(value);
          return value !== 'undefined' && angular.isString(value) && value.length;
        },
        isNumeric: function(value) {
          return angular.isNumber(Number(value));
        },
        isEmail: function(value) {
          var re;
          re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
          return re.test(value);
        },
        isMatch: function(value, valueToMatch) {
          return angular.equals(value, valueToMatch);
        },
        isPostcode: function(value, locale) {
          var re;
          re = /^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$/;
          return re.test(value);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=validation-service.js.map
