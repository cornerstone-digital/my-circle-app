(function() {
  angular.module('smartRegisterApp').directive('roleSelector', [
    function() {
      return {
        replace: true,
        restrict: 'A',
        scope: {
          list: '=roleSelector'
        },
        template: '<div class="btn-group btn-group-justified btn-group-lg">\n  <label class="btn btn-default" data-ng-class="{active: isChecked(\'MERCHANT_EMPLOYEE\')}">\n    <input type="checkbox" data-ng-checked="isChecked(\'MERCHANT_EMPLOYEE\')" data-ng-click="toggle(\'MERCHANT_EMPLOYEE\')"> Staff\n  </label>\n  <label class="btn btn-default" data-ng-class="{active: isChecked(\'MERCHANT_ADMINISTRATORS\')}">\n    <input type="checkbox" data-ng-checked="isChecked(\'MERCHANT_ADMINISTRATORS\')" data-ng-click="toggle(\'MERCHANT_ADMINISTRATORS\')"> Merchant admin\n  </label>\n</div>',
        link: function($scope, $element, $attrs) {
          $scope.isChecked = function(groupName) {
            return _.findWhere($scope.list, {
              name: groupName
            }) != null;
          };
          return $scope.toggle = function(groupName) {
            var idx;
            idx = _.pluck($scope.list, 'name').indexOf(groupName);
            if (idx > -1) {
              return $scope.list.splice(idx, 1);
            } else {
              return $scope.list.push({
                name: groupName
              });
            }
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=role-selector.js.map
