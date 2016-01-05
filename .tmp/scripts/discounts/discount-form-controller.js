(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('DiscountFormCtrl', [
    '$rootScope', '$scope', '$location', '$timeout', '$http', 'discount', 'Auth', 'DiscountService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $location, $timeout, $http, discount, Auth, DiscountService, MessagingService, ValidationService) {
      $scope.discount = discount;
      $scope.reset = function() {
        MessagingService.resetMessages();
        ValidationService.reset();
        if ($scope.discount.id != null) {
          return DiscountService.getById($scope.discount.id).then(function(response) {
            return $scope.discount = response;
          });
        } else {
          return $scope.discount = DiscountService["new"]();
        }
      };
      $scope.save = function(redirect) {
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Discount');
        if (!MessagingService.hasMessages('Discount').length) {
          $scope.locked = true;
          discount = $scope.discount;
          return DiscountService.save(discount).then(function(response) {
            if (redirect) {
              return $rootScope.back();
            } else {
              $scope.locked = false;
              return $scope.discount = response;
            }
          }, function(response) {
            console.error('update failed');
            return $scope.locked = false;
          });
        }
      };
      $scope.showDataChangedMessage = function() {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("warning", "Your discount data has changed. Don't forget to press the 'Save' button.", 'Discount');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Discount');
      };
      $scope.findNextElemByTabIndex = function(tabIndex) {
        var matchedElement;
        matchedElement = angular.element(document.querySelector("[tabindex='" + tabIndex + "']"));
        return matchedElement;
      };
      $scope.moveToNextTabIndex = function($event, $editable) {
        var currentElem, nextElem;
        currentElem = $editable;
        nextElem = [];
        if (currentElem.attrs.nexttabindex != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex);
        }
        currentElem.save();
        currentElem.hide();
        if (nextElem.length) {
          return $timeout(function() {
            return nextElem.click();
          }, 10);
        }
      };
      return $scope.keypressCallback = function($event, $editable) {
        var currentElem, nextElem;
        currentElem = $editable;
        nextElem = [];
        if (currentElem.attrs.nexttabindex != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex);
        }
        if ($event.which === 9) {
          $event.preventDefault();
          currentElem.save();
          currentElem.hide();
          if (nextElem.length) {
            $timeout(function() {
              return nextElem.click();
            }, 10);
          }
        }
        if ($event.which === 13) {
          $event.preventDefault();
          currentElem.save();
          return currentElem.hide();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=discount-form-controller.js.map
