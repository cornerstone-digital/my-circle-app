angular.module("checklist-model", []).directive "bindCompiledHtml", ($compile, $timeout) ->
  template: "<div></div>"
  scope:
    rawHtml: "=bindCompiledHtml"

  link: (scope, elem, attrs) ->
    scope.isHtml = (str) ->
      /<[a-z][\s\S]*>/i.test()

    scope.$watch "rawHtml", (value) ->
      return unless value

      if !scope.isHtml(value)
        value = "<span>#{value}</span>"

      # we want to use the scope OUTSIDE of this directive
      # (which itself is an isolate scope).
      newElem = $compile(value)(scope.$parent)
      elem.contents().remove()
      elem.append newElem
      return

    return