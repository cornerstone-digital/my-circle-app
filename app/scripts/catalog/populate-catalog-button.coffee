'use strict'

angular.module('smartRegisterApp')
.directive 'populateCatalogFor', ['Catalog', 'MerchantService','VenueService', 'catalogTemplate', (Catalog, MerchantService, VenueService, catalogTemplate) ->
  restrict: 'A'
  controller: ['$scope' ,'$route', 'MerchantService', 'VenueService', 'catalogTemplate', ($scope, $route, MerchantService, VenueService, catalogTemplate) ->
    $scope.$on 'catalog:populated', (event) ->
      $route.reload()
  ]
  link: ($scope, $element) ->
    if angular.isDefined($scope.products) && $scope.products?.length
      $element.prop 'disabled', true
    else
      $element.click ->
        Catalog.populate($scope.merchant, $scope.venue, catalogTemplate.categories ,->
          $scope.$emit "catalog:populated"
        )
]
