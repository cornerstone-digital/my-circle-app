###
Checklist-model
AngularJS directive for list of checkboxes
###
angular.module("checklist-model", []).directive "checklistModel", [
  "$parse"
  "$compile"
  ($parse, $compile) ->

    # contains
    contains = (arr, item) ->
      if angular.isArray(arr)
        i = 0

        while i < arr.length
          return true  if angular.equals(arr[i], item)
          i++
      false

    # add
    add = (arr, item) ->


      arr = (if angular.isArray(arr) then arr else [])
      i = 0

      while i < arr.length
        return arr  if angular.equals(arr[i], item)
        i++
      arr.push item
      arr

    # remove
    remove = (arr, item) ->
      if angular.isArray(arr)
        i = 0

        while i < arr.length
          if angular.equals(arr[i], item)
            arr.splice i, 1
            break
          i++
      arr

    # http://stackoverflow.com/a/19228302/1458162
    postLinkFn = (scope, elem, attrs) ->

      # compile with `ng-model` pointing to `checked`
      $compile(elem) scope

      # getter / setter for original model
      getter = $parse(attrs.checklistModel)
      setter = getter.assign

      # value added to list
      value = $parse(attrs.checklistValue)(scope.$parent)

      # watch UI checked change
      scope.$watch "checked", (newValue, oldValue) ->
        return  if newValue is oldValue
        current = getter(scope.$parent)

        if newValue is true
          setter scope.$parent, add(current, value)
        else
          setter scope.$parent, remove(current, value)
        return


      # watch original model change
      scope.$parent.$watch attrs.checklistModel, ((newArr, oldArr) ->
        scope.checked = contains(newArr, value)
        return
      ), true
      return
    return (
      restrict: "A"
      priority: 1000
      terminal: true
      scope: true
      compile: (tElement, tAttrs) ->
        throw "checklist-model should be applied to `input[type=\"checkbox\"]`."  if tElement[0].tagName isnt "INPUT" or not tElement.attr("type", "checkbox")
        throw "You should provide `checklist-value`."  unless tAttrs.checklistValue

        # exclude recursion
        tElement.removeAttr "checklist-model"

        # local scope var storing individual checkbox model
        tElement.attr "ng-model", "checked"
        postLinkFn
    )
]