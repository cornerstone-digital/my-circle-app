(function() {
  angular.module('smartRegisterApp').directive("ngTab", function() {
    return function(scope, element, attrs) {
      element.bind("keydown keypress", function(event) {
        if (event.which === 9) {
          scope.$apply(function() {
            scope.$eval(attrs.ngTab);
          });
          event.preventDefault();
        }
      });
    };
  });

}).call(this);

//# sourceMappingURL=on-tab.js.map
