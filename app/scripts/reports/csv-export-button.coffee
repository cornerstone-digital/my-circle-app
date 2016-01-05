'use strict'

angular.module('csv', [])
.config(['$compileProvider', ($compileProvider) ->
  whitelist = $compileProvider.aHrefSanitizationWhitelist()
  $compileProvider.aHrefSanitizationWhitelist whitelist.source + /|data:text\/csv\b/.source
])
.constant('csvHeader', 'data:text/csv;charset=iso-8859-1;base64,')
.factory('csvService', [ ->
  elementsToCsv: (els) ->
    _.map els, (el) ->
      text = $(el).text()
      if text.indexOf(',') >= 0 then "\"#{text}\"" else text
  tableToCsv: ($table) ->
    data = []
    data.push @elementsToCsv $table.find('thead tr:has(th):eq(0) th')
    _.each $table.find('tbody tr'), (row) =>
      data.push @elementsToCsv $(row).find('td')

    csvContent = ''

    _.forEach data, (row, i) ->
      csvContent += '\r\n' if i > 0
      csvContent += row.join ','

    return csvContent

  downloadDataURI: (options) ->
    return  unless options

    $.isPlainObject(options) or (options = data: options)

    location.href = options.data  unless $.browser?.webkit?

    options.filename or (options.filename = "download." + options.data.split(",")[0].split(";")[0].substring(5).split("/")[1])
    options.url or (options.url = "http://download-data-uri.appspot.com/")
    $("<form method=\"post\" action=\"" + options.url + "\" style=\"display:none\"><input type=\"hidden\" name=\"filename\" value=\"" + options.filename + "\"/><input type=\"hidden\" name=\"data\" value=\"" + options.data + "\"/></form>").submit().remove()

    return
])
.directive 'csvExportButton', ['csvService', 'csvHeader', '$parse', (csvService, csvHeader, $parse) ->

  replace: true
  restrict: 'E'
  scope:
    filename: '&'
  template: '<button data-ng-click="exportData()" data-ng-transclude type="button"></button>'
  transclude: true

  link: ($scope, $element, $attrs) ->

    $scope.exportData = ->
      csvContent = csvService.tableToCsv $element.parents('table')
      dataURI = csvHeader + CryptoJS.enc.Latin1.parse(csvContent).toString(CryptoJS.enc.Base64)

      csvService.downloadDataURI
        filename: $scope.filename()
        data: dataURI

      return null # returning DOM nodes to angular expressions causes an exception
]
