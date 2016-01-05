angular.module('smartRegisterApp')
  .directive 'roleSelector', [ ->

    replace: true
    restrict: 'A'

    scope:
      list: '=roleSelector'

    template: '''
      <div class="btn-group btn-group-justified btn-group-lg">
        <label class="btn btn-default" data-ng-class="{active: isChecked('MERCHANT_EMPLOYEE')}">
          <input type="checkbox" data-ng-checked="isChecked('MERCHANT_EMPLOYEE')" data-ng-click="toggle('MERCHANT_EMPLOYEE')"> Staff
        </label>
        <label class="btn btn-default" data-ng-class="{active: isChecked('MERCHANT_ADMINISTRATORS')}">
          <input type="checkbox" data-ng-checked="isChecked('MERCHANT_ADMINISTRATORS')" data-ng-click="toggle('MERCHANT_ADMINISTRATORS')"> Merchant admin
        </label>
      </div>
    '''

    link: ($scope, $element, $attrs) ->
      $scope.isChecked = (groupName) ->
        _.findWhere($scope.list, name: groupName)?

      $scope.toggle = (groupName) ->
        idx = _.pluck($scope.list, 'name').indexOf(groupName)
        if idx > -1
          $scope.list.splice idx, 1
        else
          $scope.list.push
            name: groupName
  ]
