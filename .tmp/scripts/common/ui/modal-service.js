(function() {
  angular.module("smartRegisterApp").service("modalService", [
    "$modal", function($modal) {
      var modalDefaults, modalOptions;
      modalDefaults = {
        backdrop: true,
        keyboard: true,
        modalFade: true,
        templateUrl: "views/partials/modal.html"
      };
      modalOptions = {
        closeButtonText: "Close",
        actionButtonText: "OK",
        headerText: "Proceed?",
        bodyText: "Perform this action?"
      };
      return {
        showModal: function(customModalDefaults, customModalOptions) {
          if (!customModalDefaults) {
            customModalDefaults = {};
          }
          customModalDefaults.backdrop = "static";
          return this.show(customModalDefaults, customModalOptions);
        },
        show: function(customModalDefaults, customModalOptions) {
          var tempModalDefaults, tempModalOptions;
          tempModalDefaults = {};
          tempModalOptions = {};
          angular.extend(tempModalDefaults, modalDefaults, customModalDefaults);
          angular.extend(tempModalOptions, modalOptions, customModalOptions);
          if (!tempModalDefaults.controller) {
            tempModalDefaults.controller = function($scope, $modalInstance) {
              $scope.modalOptions = tempModalOptions;
              $scope.modalOptions.ok = function(result) {
                $modalInstance.close(result);
              };
              $scope.modalOptions.close = function(result) {
                $modalInstance.dismiss("cancel");
              };
            };
          }
          return $modal.open(tempModalDefaults).result;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=modal-service.js.map
