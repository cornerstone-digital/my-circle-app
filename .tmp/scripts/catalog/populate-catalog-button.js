(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('populateCatalogFor', [
    'Catalog', 'MerchantService', 'VenueService', 'catalogTemplate', function(Catalog, MerchantService, VenueService, catalogTemplate) {
      return {
        restrict: 'A',
        controller: [
          '$scope', '$route', 'MerchantService', 'VenueService', 'catalogTemplate', function($scope, $route, MerchantService, VenueService, catalogTemplate) {
            return $scope.$on('catalog:populated', function(event) {
              return $route.reload();
            });
          }
        ],
        link: function($scope, $element) {
          var _ref;
          if (angular.isDefined($scope.products) && ((_ref = $scope.products) != null ? _ref.length : void 0)) {
            return $element.prop('disabled', true);
          } else {
            return $element.click(function() {
              return Catalog.populate($scope.merchant, $scope.venue, catalogTemplate.categories, function() {
                return $scope.$emit("catalog:populated");
              });
            });
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=populate-catalog-button.js.map
