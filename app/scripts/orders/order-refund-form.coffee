'use strict'

angular.module('smartRegisterApp')
  .directive('orderRefundForm', ['$filter', 'Config', ($filter, Config) ->
    templateUrl: 'views/partials/orders/order-refund-form.html'
    replace: true
    restrict: 'E'
    scope:
      order: '='
    controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
      $scope.fullyRefunded = ->
        $scope.order.status is 'REFUNDED' or $scope.order.basket.items.every (it) ->
          it.state is 'REFUNDED'

      $scope.isRefunded = (item) ->
        $scope.fullyRefunded() or item.state is 'REFUNDED'

      $scope.canRefund = (item) ->
        !$scope.order.splitOrder

      $scope.refundValue = ->
        if $scope.order.basket.items.some((it) -> it.toRefund)
          $scope.order.basket.items.map (it) ->
            if it.toRefund then (it.total + it.adjustment) else 0
          .reduce (a, b) -> a + b
        else
          $scope.order.basket.items.map (it) ->
            if it.state is 'REFUNDED' then 0 else (it.total + it.adjustment)
          .reduce (a, b) -> a + b

      # in embedded app mode we need to do a trick to display an alert without
      # "index.html" as the title
      displayMessage = (message) ->
        if Config.mode() is 'browser'
          alert message
        else
          iframe = document.createElement('iframe')
          iframe.setAttribute('src', 'data:text/plain')
          document.documentElement.appendChild(iframe)
          window.frames[0].window.alert(message)
          iframe.parentNode.removeChild(iframe)

      $scope.refund = ->
        $scope.$broadcast 'refund:starting'

        refundValue = $scope.refundValue()

        $scope.order.$refund
          id: $scope.order.id # TODO: we shouldn't need this
        , (order) ->
          $scope.$broadcast 'refund:complete'
          $scope.$emit 'order:updated', order
          displayMessage "Items with a value of #{$filter('currency') refundValue, '£'} refunded"
        , ->
          $scope.$broadcast 'refund:complete'
          displayMessage "Refund failed"

      $scope.refundAll = ->
        item.toRefund = false for item in $scope.order.basket.items
        $scope.refund()

      $scope.anySelected = ->
        _.some $scope.order.basket.items, (it) -> it.toRefund
    ]
  ])

