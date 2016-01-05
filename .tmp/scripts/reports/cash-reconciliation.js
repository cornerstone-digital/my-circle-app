(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('cashReconciliation', [
    function() {
      return {
        controller: [
          '$scope', function($scope) {
            return $scope.currencies = ['£20', '£10', '£5', '£2', '£1', '50p', '20p', '10p', '5p', '2p/1p', 'Other'];
          }
        ],
        restrict: 'C',
        scope: true,
        template: "<h2>Cash register reconciliation</h2>\n<table class=\"table table-bordered\">\n  <tfoot>\n    <tr>\n      <th>Total</th>\n      <td>&nbsp;</td>\n    </tr>\n  </tfoot>\n  <tbody>\n    <tr data-ng-repeat=\"currency in currencies\">\n      <th>{{currency}}</th>\n      <td>&nbsp;</td>\n    </tr>\n  </tbody>\n</table>"
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=cash-reconciliation.js.map
