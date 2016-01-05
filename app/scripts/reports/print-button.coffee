'use strict'

angular.module('smartRegisterApp')
.directive 'reportPrintButton', ['$location', ($location) ->
  replace: true
  restrict: 'E'
  template: '''\
    <div class="btn-group app-only">
       <a href="/printreport" class="btn btn-default btn-lg" data-ng-click="print('small')">Print</a>
    </div>'''
  link: ($scope, $element) ->
    $scope.print = (size) ->
      $body = $element.parents('body')
      $body.removeClass("print-#{s}") for s in ['small', 'medium', 'large']
      $body.addClass("print-#{size}")

      return true
]
