(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('OAuthCtrl', [
    '$routeParams', '$location', 'Tool', 'tools', function($routeParams, $location, Tool, tools) {
      var appId, provider, successCallback, token, tool;
      provider = $routeParams.provider;
      token = $routeParams.token;
      appId = "com.mycircleinc.smarttools.social." + provider;
      tool = _.find(tools, function(it) {
        return it.appId === appId;
      });
      successCallback = function() {
        return $location.path('/social');
      };
      if (tool != null) {
        if (tool.properties == null) {
          tool.properties = {};
        }
        tool.properties.token = token;
        return tool.$update(successCallback);
      } else {
        tool = new Tool({
          appId: appId,
          availableTo: [0, 1, 2, 3],
          displayIndex: 5,
          properties: {
            token: token
          }
        });
        return tool.$save(successCallback);
      }
    }
  ]);

}).call(this);

//# sourceMappingURL=oauth-controller.js.map
