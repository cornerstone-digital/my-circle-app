angular.module('smartRegisterApp')
.controller 'DiscountsCtrl', ['$route', '$scope', '$rootScope', '$location', 'venues', 'discounts', 'SettingsService', 'DiscountService', 'venues', ($route, $scope, $rootScope, $location, venues, discounts, SettingsService, DiscountService) ->

  $scope.discounts = discounts
  $scope.venues = venues
  $scope.venue = $rootScope.credentials.venue

  $scope.create = ->
    $location.path "/discounts/add/"

  $scope.edit = (discount) ->
    $location.path "/discounts/edit/#{discount.id}"

  $scope.save = ->
    discount = $scope.discount

    if $scope.discountForm.$valid
      if discount.id?
        discount.$update ->
          for index in [0...$scope.discounts.length]
            $scope.discounts[index] = discount if $scope.discounts[index].id is discount.id
          $scope.cancel()
      else
        discount.$save ->
          $scope.discounts.push discount
          $scope.cancel()

  $scope.remove = (discount) ->
    DiscountService.remove(discount).then(->
      index = $scope.discounts.indexOf(discount)
      $scope.discounts.splice index, 1
    , ->
      console.error "could not delete", discount
      $scope.$broadcast "delete:failed", discount
    )

  $scope.toggleAvailableTo = (role) ->
    idx = $scope.discount.availableTo.indexOf(role);
    if idx > -1
      $scope.discount.availableTo.splice idx, 1
    else
      $scope.discount.availableTo.push role

  $scope.canAddDiscount = ->
    $scope.discounts.length < 3

  $scope.hasModuleEnabled = (moduleName) ->
    SettingsService.hasModuleEnabled moduleName

  $scope.hasMultipleVenues = ->
    if($scope.venues.length > 1)
      return true
    else
      return false

  $scope.switchVenue = (venue) ->
    $scope.$broadcast 'venue:switch', venue

  $scope.$on 'venue:switch', (event, venue) ->
      $rootScope.credentials.venue = venue
      $route.reload()

]

