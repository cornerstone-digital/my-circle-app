(function() {
  'use strict';
  angular.module('csv', []).config([
    '$compileProvider', function($compileProvider) {
      var whitelist;
      whitelist = $compileProvider.aHrefSanitizationWhitelist();
      return $compileProvider.aHrefSanitizationWhitelist(whitelist.source + /|data:text\/csv\b/.source);
    }
  ]).constant('csvHeader', 'data:text/csv;charset=iso-8859-1;base64,').factory('csvService', [
    function() {
      return {
        elementsToCsv: function(els) {
          return _.map(els, function(el) {
            var text;
            text = $(el).text();
            if (text.indexOf(',') >= 0) {
              return "\"" + text + "\"";
            } else {
              return text;
            }
          });
        },
        tableToCsv: function($table) {
          var csvContent, data;
          data = [];
          data.push(this.elementsToCsv($table.find('thead tr:has(th):eq(0) th')));
          _.each($table.find('tbody tr'), (function(_this) {
            return function(row) {
              return data.push(_this.elementsToCsv($(row).find('td')));
            };
          })(this));
          csvContent = '';
          _.forEach(data, function(row, i) {
            if (i > 0) {
              csvContent += '\r\n';
            }
            return csvContent += row.join(',');
          });
          return csvContent;
        },
        downloadDataURI: function(options) {
          var _ref;
          if (!options) {
            return;
          }
          $.isPlainObject(options) || (options = {
            data: options
          });
          if (((_ref = $.browser) != null ? _ref.webkit : void 0) == null) {
            location.href = options.data;
          }
          options.filename || (options.filename = "download." + options.data.split(",")[0].split(";")[0].substring(5).split("/")[1]);
          options.url || (options.url = "http://download-data-uri.appspot.com/");
          $("<form method=\"post\" action=\"" + options.url + "\" style=\"display:none\"><input type=\"hidden\" name=\"filename\" value=\"" + options.filename + "\"/><input type=\"hidden\" name=\"data\" value=\"" + options.data + "\"/></form>").submit().remove();
        }
      };
    }
  ]).directive('csvExportButton', [
    'csvService', 'csvHeader', '$parse', function(csvService, csvHeader, $parse) {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          filename: '&'
        },
        template: '<button data-ng-click="exportData()" data-ng-transclude type="button"></button>',
        transclude: true,
        link: function($scope, $element, $attrs) {
          return $scope.exportData = function() {
            var csvContent, dataURI;
            csvContent = csvService.tableToCsv($element.parents('table'));
            dataURI = csvHeader + CryptoJS.enc.Latin1.parse(csvContent).toString(CryptoJS.enc.Base64);
            csvService.downloadDataURI({
              filename: $scope.filename(),
              data: dataURI
            });
            return null;
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=csv-export-button.js.map
