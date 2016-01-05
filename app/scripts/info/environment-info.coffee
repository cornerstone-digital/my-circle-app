'use strict'

angular.module('smartRegisterApp').directive 'environmentInfo', ['$rootScope', 'Config', 'Auth', 'versionCheckService', 'MessagingService', ($rootScope, Config, Auth, versionCheckService, MessagingService) ->
  replace: true
  restrict: 'E'
  scope: true
  template: '''
  <div class="navbar navbar-inverse navbar-fixed-bottom environment-info" data-ng-if="shouldDisplay()">
    <div class="container-fluid" data-ng-show="serverInformation">
      <div class="pull-left">
        <p class="navbar-text">Dashboard: <span style="text-transform: uppercase">{{dashboardVersion()}}</span> ({{gitHash()}})</p>
        <form class="navbar-form navbar-left" data-requires-permission="PERM_PLATFORM_ADMINISTRATOR">
          <div class="form-group merchant-selector"></div>
        </form>
      </div>
      <div class="navbar-right">
        <p class="navbar-text">Server: {{serverInformation().version}} ({{serverInformation().commitId}})</p>
        <p class="navbar-text">API: {{serverInformation().apiVersion}}</p>
        <p class="navbar-text">Build date: {{serverInformation().buildDate}}</p>
        <p class="navbar-text">Environment: {{serverInformation().environment}}</p>
      </div>
    </div>
  </div>
  '''
  link: ($scope) ->
    versionCheckService.startPolling()
    $scope.hasRole = (roleName) ->
      Auth.hasRole(roleName)

    $scope.shouldDisplay = -> Config.mode() is 'browser'
    $scope.dashboardVersion = -> versionCheckService.currentVersion()
    $scope.serverInformation = -> versionCheckService.serverInformation()
    $scope.gitHash = -> versionCheckService.getHash()

    $scope.$on 'posversion:changed', (event, serverInformation) ->
      message = "There is a new version of the iOS App available. You currently have version #{$rootScope.posVersion}. Version #{serverInformation.latestPosVersion} is now available."
      toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-top-full-width",
        "onclick": null,
        "showDuration": "1000",
        "hideDuration": "1000",
        "timeOut": "0",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
      }
      toastr.clear()
      toastr.info(message)
]
