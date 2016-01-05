(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('dragSort', [
    function() {
      return {
        scope: {
          array: '=dragSort',
          disabled: '=dragDisabled'
        },
        link: function($scope, $element, $attrs) {
          $element.sortable({
            containment: 'body',
            tolerance: 'pointer',
            start: function(event, ui) {
              ui.item.data('start', ui.item.index());
              return $scope.$parent.$broadcast("" + $attrs.dragSort + ":" + event.type);
            },
            update: function(event, ui) {
              var end, start;
              start = ui.item.data('start');
              end = ui.item.index();
              $scope.$apply(function() {
                return $scope.array.splice(end, 0, $scope.array.splice(start, 1)[0]);
              });
              return $scope.$emit("" + $attrs.dragSort + ":" + event.type, $scope.array);
            }
          });
          return $scope.$watch('disabled', function(newValue) {
            return $element.sortable(newValue ? 'disable' : 'enable');
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=drag-sort.js.map
