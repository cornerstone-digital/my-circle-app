'use strict'

angular.module('smartRegisterApp')
  .directive 'cashReconciliation', [ ->
    controller: ['$scope', ($scope) ->
      $scope.currencies = ['£20', '£10', '£5', '£2', '£1', '50p', '20p', '10p', '5p', '2p/1p', 'Other']
    ]
    restrict: 'C'
    scope: true
    template: """
    <h2>Cash register reconciliation</h2>
    <table class="table table-bordered">
      <tfoot>
        <tr>
          <th>Total</th>
          <td>&nbsp;</td>
        </tr>
      </tfoot>
      <tbody>
        <tr data-ng-repeat="currency in currencies">
          <th>{{currency}}</th>
          <td>&nbsp;</td>
        </tr>
      </tbody>
    </table>
    """
  ]
