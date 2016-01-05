'use strict'

angular.module('smartRegisterApp')
.directive 'dateRange', [ ->
  replace: false
  require: '^form'
  restrict: 'A'
  scope:
    dateRange: '='
    disabled: '='
  template: '''\
    <select data-ng-model="range" class="form-control input-lg" data-ng-disabled="disabled">
      <option value="today">Today</option>
      <option value="yesterday">Yesterday</option>
      <option value="this-week">This week</option>
      <option value="last-week">Last week</option>
      <option value="this-month">This month</option>
      <option value="last-month">Last month</option>
      <option value="this-year">This year</option>
      <option value="custom">Custom date</option>
    </select>
    <span data-ng-hide="range != 'custom'">
      <input name="dateRangeFrom" type="datetime-local" data-datetime-local data-ng-model="dateRange.from" data-ng-readonly="range != 'custom'" data-ng-disabled="disabled" class="form-control input-lg">
      <label>to</label>
      <input name="dateRangeTo" type="datetime-local" data-datetime-local data-ng-model="dateRange.to" data-ng-readonly="range != 'custom'" data-ng-disabled="disabled" class="form-control input-lg">
    </span>
    <p class="error">Invalid date range</p>
  '''
  link: ($scope, $element, $attrs, formController) ->
    validateRange = (from, to) ->
      if $scope.range is 'custom' and (not from? or not to?)
        formController.dateRangeTo.$setValidity 'range', false
      else if to?.isBefore from
        formController.dateRangeTo.$setValidity 'range', false
      else
        formController.dateRangeTo.$setValidity 'range', true

    # $scope.$watch 'disabled', (value) ->
    #   $element.find('select').prop('disabled', value)

    $scope.$watch 'dateRange.from', (value) -> validateRange value, $scope.dateRange.to
    $scope.$watch 'dateRange.to', (value) -> validateRange $scope.dateRange.from, value

    $scope.$watch 'range', (value) ->
      switch value
        when 'custom'
          $scope.dateRange.from = moment().local().startOf('day')
          $scope.dateRange.to = moment().endOf('day')
        when 'today'
          $scope.dateRange.from = moment().local().startOf('day')
          $scope.dateRange.to = null
        when 'yesterday'
          $scope.dateRange.from = moment().local().subtract('days', 1).startOf('day')
          $scope.dateRange.to = moment().local().startOf('day')
        when 'this-week'
          $scope.dateRange.from = moment().local().startOf('week')
          $scope.dateRange.to = moment().local().endOf('week')
        when 'last-week'
          $scope.dateRange.from = moment().local().subtract('weeks', 1).startOf('week')
          $scope.dateRange.to = moment().local().subtract('weeks', 1).endOf('week')
        when 'this-month'
          $scope.dateRange.from = moment().local().startOf('month')
          $scope.dateRange.to = moment().local().endOf('month')
        when 'last-month'
          $scope.dateRange.from = moment().local().subtract('months', 1).startOf('month')
          $scope.dateRange.to = moment().local().subtract('months', 1).endOf('month')
        when 'this-year'
          $scope.dateRange.from = moment().local().startOf('year')
          $scope.dateRange.to = moment().local().endOf('year')

    unless $scope.range?
      $scope.range = 'today'
]
