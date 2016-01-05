(function() {
  'use strict';

  /*
  Creates a sortable column header for a table.
   */
  angular.module('smartRegisterApp').directive('sortable', [
    function() {
      return {
        replace: false,
        restrict: 'A',
        template: '<a href="" data-ng-transclude></a>',
        transclude: true,
        link: function($scope, $element, $attrs) {
          var sortableExpr;
          sortableExpr = $attrs.sortable;
          $element.delegate('a', 'click', function() {
            return $scope.$apply(function() {
              $scope.reverse = $scope.sort === sortableExpr ? !$scope.reverse : false;
              return $scope.sort = sortableExpr;
            });
          });
          $scope.$watch('sort', function(value) {
            return $element.toggleClass('active', value === sortableExpr);
          });
          return $scope.$watch('reverse', function(value) {
            return $element.toggleClass('desc', value);
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=sortable.js.map
