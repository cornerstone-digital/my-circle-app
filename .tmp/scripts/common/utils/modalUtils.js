(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('ModalService', [
    '$rootScope', '$compile', function($rootScope, $compile) {
      var ModalUtils;
      ModalUtils = {};
      ModalUtils.repositionWindow = function(elementName) {
        var d, left, top;
        d = $('#' + elementName).closest('.k-window');
        left = ($(window).width() - $(d).outerWidth()) / 2;
        top = ($(window).height() - $(d).outerWidth()) / 2;
        d.css({
          position: 'absolute',
          left: left,
          top: top
        });
      };
      ModalUtils.createWindow = function(elementName, options) {
        var defaults, ngInclude, templateUrl, window;
        defaults = {
          scope: null,
          templateUrl: null,
          title: null,
          width: 600,
          height: null,
          modal: true,
          actions: ["Maximize", "Close"],
          apiEvents: {
            onOpen: null,
            onClose: null,
            onActivate: null,
            onDeactivate: null,
            onDragend: null,
            onResize: null,
            onRefresh: null
          }
        };
        if (typeof options === 'object') {
          options = $.extend(defaults, options);
        } else {
          options = defaults;
        }
        $("body").append("<div id=\"" + elementName + "\"></div>");
        window = $("#" + elementName);
        if (options.templateUrl != null) {
          templateUrl = "'" + options.templateUrl + "'";
          ngInclude = $compile('<ng-include src="' + templateUrl + '"></ng-include>')(options.scope);
          window.append(ngInclude);
          $compile(window);
        }
        if (!window.data("kendoWindow")) {
          return window.kendoWindow({
            width: options.width + "px",
            height: options.height + "px",
            title: options.title,
            actions: options.actions,
            modal: options.modal,
            open: function() {
              if (typeof options.apiEvents.open === 'function') {
                options.apiEvents.open();
              }
            },
            close: function() {
              $("#" + elementName).data("kendoWindow").destroy();
              if (typeof options.apiEvents.onClose === 'function') {
                options.apiEvents.onClose();
              }
            },
            activate: function(e) {
              ModalUtils.repositionWindow(elementName);
              if (typeof options.apiEvents.onActivate === 'function') {
                options.apiEvents.onActivate();
              }
            },
            deactivate: function(e) {
              if (typeof options.apiEvents.onDeactivate === 'function') {
                options.apiEvents.onDeactivate();
              }
            },
            dragend: function(e) {
              ModalUtils.repositionWindow(elementName);
              if (typeof options.apiEvents.onDragend === 'function') {
                options.apiEvents.onDragend();
              }
            },
            resize: function(e) {
              ModalUtils.repositionWindow(elementName);
              if (typeof options.apiEvents.onResize === 'function') {
                options.apiEvents.onResize();
              }
            }
          });
        }
      };
      return ModalUtils;
    }
  ]);

}).call(this);

//# sourceMappingURL=modalUtils.js.map
