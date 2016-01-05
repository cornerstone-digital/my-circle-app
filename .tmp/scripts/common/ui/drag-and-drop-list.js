(function() {
  angular.module('smartRegisterApp').directive("dragAndDropList", function() {
    return function(scope, element, attrs) {
      var startIndex, toUpdate;
      toUpdate = null;
      startIndex = -1;
      scope.$watch(attrs.dragAndDropList, (function(value) {
        toUpdate = value;
      }), true);
      $(element[0]).sortable({
        items: "li",
        start: function(event, ui) {
          startIndex = $(ui.item).index();
        },
        stop: function(event, ui) {
          var newIndex, toMove;
          newIndex = $(ui.item).index();
          toMove = toUpdate[startIndex];
          toUpdate.splice(startIndex, 1);
          toUpdate.splice(newIndex, 0, toMove);
          scope.$apply(scope.model);
        },
        axis: "y"
      });
    };
  });

}).call(this);

//# sourceMappingURL=drag-and-drop-list.js.map
