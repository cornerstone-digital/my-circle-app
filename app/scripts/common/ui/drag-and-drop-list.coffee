# directive for a single list
angular.module('smartRegisterApp')
.directive "dragAndDropList", ->
  (scope, element, attrs) ->

    # variables used for dnd
    toUpdate = null
    startIndex = -1

    # watch the model, so we always know what element
    # is at a specific position
    scope.$watch attrs.dragAndDropList, ((value) ->
      toUpdate = value
      return
    ), true

    # use jquery to make the element sortable (dnd). This is called
    # when the element is rendered
    $(element[0]).sortable
      items: "li"
      start: (event, ui) ->

        # on start we define where the item is dragged from
        startIndex = ($(ui.item).index())
        return

      stop: (event, ui) ->

        # on stop we determine the new index of the
        # item and store it there
        newIndex = ($(ui.item).index())
        toMove = toUpdate[startIndex]
        toUpdate.splice startIndex, 1
        toUpdate.splice newIndex, 0, toMove

        # we move items in the array, if we want
        # to trigger an update in angular use $apply()
        # since we're outside angulars lifecycle
        scope.$apply scope.model
        return

      axis: "y"

    return
