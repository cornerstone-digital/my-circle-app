(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('UITestsCtrl', [
    '$rootScope', '$scope', 'SettingsService', '$location', function($rootScope, $scope, SettingsService, $location) {
      $scope.today = function() {
        return $scope.dt = new Date();
      };
      $scope.today();
      $scope.clear = function() {
        return $scope.dt = null;
      };
      $scope.disabled = function(date, mode) {
        return mode === "day" && (date.getDay() === 0 || date.getDay() === 6);
      };
      $scope.toggleMin = function() {
        return $scope.minDate = ($scope.minDate ? null : new Date());
      };
      $scope.toggleMin();
      $scope.open = function($event) {
        $event.preventDefault();
        $event.stopPropagation();
        return $scope.opened = true;
      };
      $scope.dateOptions = {
        formatYear: "yy",
        startingDay: 1
      };
      $scope.initDate = new Date("2016-15-20");
      $scope.formats = ["dd-MMMM-yyyy", "yyyy/MM/dd", "dd.MM.yyyy", "shortDate"];
      return $scope.format = $scope.formats[0];
    }
  ]);

}).call(this);

//# sourceMappingURL=ui-tests-controller.js.map
