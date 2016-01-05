(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('OrdersCtrl', [
    '$scope', 'Order', 'orders', function($scope, Order, orders) {
      $scope.orders = orders;
      $scope.search = function() {
        $scope.orders = [];
        return Order.query({
          orderId: $scope.orderId,
          from: '1970-01-01T00:00'
        }, function(orders) {
          return $scope.orders = orders;
        });
      };
      $scope.clear = function() {
        $scope.orderId = '';
        return $scope.search();
      };
      return $scope.$on('order:updated', function(event, order) {
        var index, _i, _ref, _results;
        _results = [];
        for (index = _i = 0, _ref = $scope.orders.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
          if ($scope.orders[index].id === order.id) {
            _results.push($scope.orders[index] = angular.copy(order));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=orders-controller.js.map
