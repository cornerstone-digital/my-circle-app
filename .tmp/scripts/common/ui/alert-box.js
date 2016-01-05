(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('alertBox', [
    '$rootScope', 'MessagingService', function($rootScope, MessagingService) {
      return {
        replace: true,
        restrict: 'E',
        template: '<div class="alerts-box alert alert-info row" data-ng-if="hasMessages()" style="margin-top: 50px">\n  <ul ng-repeat="message in filteredMessages" class="col-md-12">\n    <li class="message icon-{{message.type}}">\n      {{message.text}}\n      <a href="{{message.linkUrl}}" title="{{message.linkText}}" data-ng-if="hasLink(message)">{{message.linkText}}</a>\n    </li>\n  </ul>\n</div>',
        scope: true,
        link: function($scope, $element, $attrs, controllers) {
          var group;
          group = $attrs.group;
          $scope.hasMessages = function() {
            return MessagingService.hasMessages(group).length;
          };
          $scope.hasErrors = function() {
            return MessagingService.getMessagesByType('error').length;
          };
          return $scope.hasLink = function(message) {
            return (message.linkUrl != null) && (message.linkText != null);
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=alert-box.js.map
