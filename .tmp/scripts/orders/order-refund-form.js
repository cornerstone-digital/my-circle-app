(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('orderRefundForm', [
    '$filter', 'Config', function($filter, Config) {
      return {
        templateUrl: 'views/partials/orders/order-refund-form.html',
        replace: true,
        restrict: 'E',
        scope: {
          order: '='
        },
        controller: [
          '$scope', '$element', '$attrs', function($scope, $element, $attrs) {
            var displayMessage;
            $scope.fullyRefunded = function() {
              return $scope.order.status === 'REFUNDED' || $scope.order.basket.items.every(function(it) {
                return it.state === 'REFUNDED';
              });
            };
            $scope.isRefunded = function(item) {
              return $scope.fullyRefunded() || item.state === 'REFUNDED';
            };
            $scope.canRefund = function(item) {
              return !$scope.order.splitOrder;
            };
            $scope.refundValue = function() {
              if ($scope.order.basket.items.some(function(it) {
                return it.toRefund;
              })) {
                return $scope.order.basket.items.map(function(it) {
                  if (it.toRefund) {
                    return it.total + it.adjustment;
                  } else {
                    return 0;
                  }
                }).reduce(function(a, b) {
                  return a + b;
                });
              } else {
                return $scope.order.basket.items.map(function(it) {
                  if (it.state === 'REFUNDED') {
                    return 0;
                  } else {
                    return it.total + it.adjustment;
                  }
                }).reduce(function(a, b) {
                  return a + b;
                });
              }
            };
            displayMessage = function(message) {
              var iframe;
              if (Config.mode() === 'browser') {
                return alert(message);
              } else {
                iframe = document.createElement('iframe');
                iframe.setAttribute('src', 'data:text/plain');
                document.documentElement.appendChild(iframe);
                window.frames[0].window.alert(message);
                return iframe.parentNode.removeChild(iframe);
              }
            };
            $scope.refund = function() {
              var refundValue;
              $scope.$broadcast('refund:starting');
              refundValue = $scope.refundValue();
              return $scope.order.$refund({
                id: $scope.order.id
              }, function(order) {
                $scope.$broadcast('refund:complete');
                $scope.$emit('order:updated', order);
                return displayMessage("Items with a value of " + ($filter('currency')(refundValue, '£')) + " refunded");
              }, function() {
                $scope.$broadcast('refund:complete');
                return displayMessage("Refund failed");
              });
            };
            $scope.refundAll = function() {
              var item, _i, _len, _ref;
              _ref = $scope.order.basket.items;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                item = _ref[_i];
                item.toRefund = false;
              }
              return $scope.refund();
            };
            return $scope.anySelected = function() {
              return _.some($scope.order.basket.items, function(it) {
                return it.toRefund;
              });
            };
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=order-refund-form.js.map
