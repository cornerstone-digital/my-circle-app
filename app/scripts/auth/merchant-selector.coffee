'use strict'

angular.module('smartRegisterApp')
.directive 'merchantSelector', [ ->
  restrict: 'C'
  scope: true
  template: '''
    <select class="form-control input-sm"
            data-ng-show="merchants.length"
            data-ng-model="merchant"
            data-ng-options="merchant.name for merchant in merchants track by merchant.id"
            data-ng-change="switchMerchant(merchant)"
            data-requires-permission="PERM_PLATFORM_ADMINISTRATOR"
            required>
    </select>'''
  controller: ['$scope', '$rootScope', '$route', 'Auth', 'Merchant', 'MerchantService', ($scope, $rootScope, $route, Auth, Merchant, MerchantService) ->

    $scope.switchMerchant = (merchant) ->

      Auth.impersonateMerchant merchant, ->
        $route.reload()

    $scope.canSwitchMerchant = ->
      Auth.hasRole 'PERM_PLATFORM_ADMINISTRATOR'

    if $scope.canSwitchMerchant()
      $scope.merchant = Auth.getMerchant()
      $scope.venue = Auth.getVenue()

      MerchantService.getList().then((response) ->
        $rootScope.merchants = response
        $rootScope.merchantCount = response.length
      )

    $scope.$on 'auth:updated', ->
      $scope.merchant = Auth.getMerchant()

    $scope.$on 'merchant:created', (event, merchant) ->
      $rootScope.merchants.push merchant if merchant.enabled
  ]
]