(function() {
  angular.module("checklist-model", []).directive("bindCompiledHtml", function($compile, $timeout) {
    return {
      template: "<div></div>",
      scope: {
        rawHtml: "=bindCompiledHtml"
      },
      link: function(scope, elem, attrs) {
        scope.isHtml = function(str) {
          return /<[a-z][\s\S]*>/i.test();
        };
        scope.$watch("rawHtml", function(value) {
          var newElem;
          if (!value) {
            return;
          }
          if (!scope.isHtml(value)) {
            value = "<span>" + value + "</span>";
          }
          newElem = $compile(value)(scope.$parent);
          elem.contents().remove();
          elem.append(newElem);
        });
      }
    };
  });

}).call(this);

//# sourceMappingURL=bind-compiled-html.js.map
