'use strict'

angular.module('smartRegisterApp')
.directive 'alertBox', ['$rootScope', 'MessagingService', ($rootScope, MessagingService) ->
  replace: true
  restrict: 'E'
  template: '''
      <div class="alerts-box alert alert-info row" data-ng-if="hasMessages()" style="margin-top: 50px">
        <ul ng-repeat="message in filteredMessages" class="col-md-12">
          <li class="message icon-{{message.type}}">
            {{message.text}}
            <a href="{{message.linkUrl}}" title="{{message.linkText}}" data-ng-if="hasLink(message)">{{message.linkText}}</a>
          </li>
        </ul>
      </div>
    '''
  scope: true
  link: ($scope, $element, $attrs, controllers) ->
    group = $attrs.group

    $scope.hasMessages = ->
      MessagingService.hasMessages(group).length

    $scope.hasErrors = ->
      MessagingService.getMessagesByType('error').length

    $scope.hasLink = (message) ->
      message.linkUrl? and message.linkText?

]