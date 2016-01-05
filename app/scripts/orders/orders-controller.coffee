'use strict'

angular.module('smartRegisterApp')
  .controller('OrdersCtrl', ['$scope', 'Order', 'orders', ($scope, Order, orders) ->
    $scope.orders = orders

    $scope.search = ->
      $scope.orders = []
      Order.query
        orderId: $scope.orderId
        from: '1970-01-01T00:00'
      , (orders) ->
        $scope.orders = orders

    $scope.clear = ->
      $scope.orderId = ''
      $scope.search()

    $scope.$on 'order:updated', (event, order) ->
      for index in [0...$scope.orders.length]
        $scope.orders[index] = angular.copy(order) if $scope.orders[index].id is order.id
  ])
