'use strict'

angular.module('smartRegisterApp')
.factory 'ModalService', ['$rootScope', '$compile', ($rootScope, $compile) ->
  ModalUtils = {}

  ModalUtils.repositionWindow = (elementName) ->
    d = $('#' + elementName).closest('.k-window')

    left = ($(window).width() - $(d).outerWidth()) / 2
    top = ($(window).height() - $(d).outerWidth()) / 2


    d.css(
      position:'absolute',
      left: left
      top: top
    )

    return

  ModalUtils.createWindow = (elementName, options) ->
    defaults =
      scope: null
      templateUrl: null
      title: null
      width: 600
      height: null
      modal: true
      actions:[
        "Maximize"
        "Close"
      ]
      apiEvents: {
        onOpen: null
        onClose: null
        onActivate: null
        onDeactivate: null
        onDragend: null
        onResize: null
        onRefresh: null
      }


    if (typeof options == 'object')
      options = $.extend(defaults, options)
    else
      options = defaults

    $("body").append "<div id=\"" + elementName + "\"></div>"
    window = $("#" + elementName)
    if options.templateUrl?
      templateUrl = "'" + options.templateUrl + "'"
      ngInclude = $compile('<ng-include src="' + templateUrl + '"></ng-include>')(options.scope)
      window.append(ngInclude)
      $compile(window)

    unless window.data("kendoWindow")
      window.kendoWindow
        width: options.width + "px"
        height: options.height + "px"
        title: options.title
        actions: options.actions
        modal: options.modal
        open: ->
          if typeof options.apiEvents.open == 'function'
            options.apiEvents.open()
          return

        close: ->
          $("#" + elementName).data("kendoWindow").destroy()

          if typeof options.apiEvents.onClose == 'function'
            options.apiEvents.onClose()
          return

        activate: (e) ->
          ModalUtils.repositionWindow elementName

          if typeof options.apiEvents.onActivate == 'function'
            options.apiEvents.onActivate()
          return

        deactivate: (e) ->
          if typeof options.apiEvents.onDeactivate == 'function'
            options.apiEvents.onDeactivate()
          return

        dragend: (e) ->
          ModalUtils.repositionWindow elementName

          if typeof options.apiEvents.onDragend == 'function'
            options.apiEvents.onDragend()
          return

        resize: (e) ->
          ModalUtils.repositionWindow elementName

          if typeof options.apiEvents.onResize == 'function'
            options.apiEvents.onResize()
          return

  return ModalUtils
]
