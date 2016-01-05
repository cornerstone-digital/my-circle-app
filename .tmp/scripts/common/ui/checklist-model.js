
/*
Checklist-model
AngularJS directive for list of checkboxes
 */

(function() {
  angular.module("checklist-model", []).directive("checklistModel", [
    "$parse", "$compile", function($parse, $compile) {
      var add, contains, postLinkFn, remove;
      contains = function(arr, item) {
        var i;
        if (angular.isArray(arr)) {
          i = 0;
          while (i < arr.length) {
            if (angular.equals(arr[i], item)) {
              return true;
            }
            i++;
          }
        }
        return false;
      };
      add = function(arr, item) {
        var i;
        arr = (angular.isArray(arr) ? arr : []);
        i = 0;
        while (i < arr.length) {
          if (angular.equals(arr[i], item)) {
            return arr;
          }
          i++;
        }
        arr.push(item);
        return arr;
      };
      remove = function(arr, item) {
        var i;
        if (angular.isArray(arr)) {
          i = 0;
          while (i < arr.length) {
            if (angular.equals(arr[i], item)) {
              arr.splice(i, 1);
              break;
            }
            i++;
          }
        }
        return arr;
      };
      postLinkFn = function(scope, elem, attrs) {
        var getter, setter, value;
        $compile(elem)(scope);
        getter = $parse(attrs.checklistModel);
        setter = getter.assign;
        value = $parse(attrs.checklistValue)(scope.$parent);
        scope.$watch("checked", function(newValue, oldValue) {
          var current;
          if (newValue === oldValue) {
            return;
          }
          current = getter(scope.$parent);
          if (newValue === true) {
            setter(scope.$parent, add(current, value));
          } else {
            setter(scope.$parent, remove(current, value));
          }
        });
        scope.$parent.$watch(attrs.checklistModel, (function(newArr, oldArr) {
          scope.checked = contains(newArr, value);
        }), true);
      };
      return {
        restrict: "A",
        priority: 1000,
        terminal: true,
        scope: true,
        compile: function(tElement, tAttrs) {
          if (tElement[0].tagName !== "INPUT" || !tElement.attr("type", "checkbox")) {
            throw "checklist-model should be applied to `input[type=\"checkbox\"]`.";
          }
          if (!tAttrs.checklistValue) {
            throw "You should provide `checklist-value`.";
          }
          tElement.removeAttr("checklist-model");
          tElement.attr("ng-model", "checked");
          return postLinkFn;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=checklist-model.js.map
