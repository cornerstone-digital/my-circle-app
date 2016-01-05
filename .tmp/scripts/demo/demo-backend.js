(function() {
  'use strict';
  angular.module('demoBackend', ['ngMockE2E', 'smartRegisterApp']).run([
    '$httpBackend', 'Config', 'authResponse', 'merchantsResponse', 'venuesResponse', 'posResponse', 'reportsResponse', 'ordersResponse', function($httpBackend, Config, authResponse, merchantsResponse, venuesResponse, posResponse, reportsResponse, ordersResponse) {
      console.warn("Activating demo mode...");
      $httpBackend.whenGET(/.*\/authenticate$/).respond(authResponse);
      $httpBackend.whenGET(/.*\/merchants$/).respond(merchantsResponse);
      $httpBackend.whenGET(/.*\/venues$/).respond(venuesResponse);
      $httpBackend.whenGET(/.*\/venues\/\w+\/pos/).respond(posResponse);
      $httpBackend.whenGET(/.*\/venues\/\w+\/reports(\?.*)?/).respond(reportsResponse);
      $httpBackend.whenGET(/.*\/venues\/\w+\/orders\?.*/).respond(ordersResponse);
      return $httpBackend.whenGET(/views\/\w*/).passThrough();
    }
  ]);

  angular.module('smartRegisterApp').requires.push('demoBackend');

}).call(this);

//# sourceMappingURL=demo-backend.js.map
