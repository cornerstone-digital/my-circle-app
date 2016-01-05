(function() {
  angular.module('smartRegisterApp').directive('validateData', [
    '$timeout', function($timeout) {
      return {
        restrict: "A",
        scope: {
          data: '=validateData',
          rules: '=rules',
          match: '=matchData'
        },
        controller: [
          '$scope', 'MessagingService', 'ValidationService', function($scope, MessagingService, ValidationService) {
            $scope.hasRule = function(rules, ruleName) {
              var matched;
              matched = false;
              angular.forEach(rules, function(value, index) {
                if (value === ruleName) {
                  return matched = true;
                }
              });
              return matched;
            };
            return $scope.validate = function($scope, $element, $attrs) {
              var errorFound, label, matchElement, type, value1, value2;
              label = $element.find('label:first');
              $scope.error = null;
              if ($scope.hasRule($scope.rules, 'required')) {
                if (!$attrs.type) {
                  type = null;
                }
                if (!ValidationService.isRequired($scope.data, type)) {
                  errorFound = true;
                }
                if (errorFound) {
                  $scope.error = MessagingService.createMessage('error', $attrs.displayname + ' is required.', $attrs.groupname);
                  MessagingService.addMessage($scope.error);
                }
              }
              if ($scope.hasRule($scope.rules, 'numeric')) {
                if (!ValidationService.isNumeric($scope.data)) {
                  $scope.error = MessagingService.createMessage('error', $attrs.displayname + ' must be numeric', $attrs.groupname);
                  MessagingService.addMessage($scope.error);
                }
              }
              if ($scope.hasRule($scope.rules, 'match')) {
                matchElement = angular.element(document.querySelector("input[name=" + $attrs.matchData + "]"));
                value1 = $scope.data;
                value2 = matchElement[0].value;
                if (!ValidationService.isMatch(value1, value2)) {
                  $scope.error = MessagingService.createMessage('error', "The values of ''" + matchElement.parent().context.placeholder + "' and '" + $attrs.displayname + "' must match.", $attrs.groupname);
                  MessagingService.addMessage($scope.error);
                }
              }
              if ($scope.hasRule($scope.rules, 'email')) {
                if (!ValidationService.isEmail($scope.data)) {
                  $scope.error = MessagingService.createMessage('error', $attrs.displayname + " must be a valid email address.", $attrs.groupname);
                  MessagingService.addMessage($scope.error);
                }
              }
              if ($scope.error != null) {
                label.addClass('hasError');
                return delete $scope.error;
              }
            };
          }
        ],
        link: function($scope, $element, $attrs) {
          $scope.$on('validate-data:validate', function($event, group) {
            if ($attrs.groupname === group) {
              return $scope.validate($scope, $element, $attrs);
            }
          });
          return $scope.$on('validate-data:reset', function() {
            var label;
            label = $element.find('label:first');
            return label.removeClass('hasError');
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=validate-data.js.map
