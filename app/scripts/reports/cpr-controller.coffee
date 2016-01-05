angular.module('smartRegisterApp')
.controller 'CPRReportCtrl', ['$rootScope', '$scope', '$timeout', '$route', '$filter', 'venues', 'POSList', "POSName", 'venue', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', ($rootScope, $scope, $timeout, $route, $filter, venues, POSList, POSName, venue, ReportsService, POSService, MessagingService, ValidationService) ->
  $scope.readOnly = ->
    $scope.readonly

  $scope.hasErrors = ->
    MessagingService.hasMessages('CPRReport').length


  $scope.setDateValues = (openingDate, closingDate) ->
    now = moment(new Date())

    $scope.openingDate = moment(openingDate) if openingDate
    $scope.closingDate = moment(closingDate) if closingDate

    if $scope.openingDate > now
      $scope.openingDate = now

    if $scope.closingDate > now
      $scope.closingDate = now

    return

  $scope.setDatePickers = (opening, closing) ->
    $scope.setDateValues(opening, closing)

    $timeout ->
      if $scope.opening?
        $scope.opening.min(kendo.parseDate($scope.openingDate.toISOString()))
        $scope.opening.max(kendo.parseDate($scope.closingDate.toISOString()))

      if $scope.closing?
        $scope.closing.min(kendo.parseDate($scope.openingDate.toISOString()))
        $scope.closing.max(kendo.parseDate($scope.closingDate.toISOString()))
    , 1000

  $scope.updateVenue = (e) ->
    dataItem = this.dataItem(e.item.index())
    $scope.venueId = dataItem.id

    POSService.getList($scope.venueId).then((response)->
      $('#posId').data("kendoDropDownList").setDataSource(response)
      if response.length
        $('#posId').data("kendoDropDownList").refresh()
        $('#posId').data("kendoDropDownList").enable()
      else
        $('#posId').data("kendoDropDownList").enable(false)
    )

    $scope.generateReport()

  $scope.updatePOS = (e) ->
    dataItem = this.dataItem(e.item.index())
    $scope.posId = dataItem.id
    $scope.POS = dataItem

    $scope.generateReport()

  $scope.getPOS = (id, name) ->
    $scope.POS = null unless $scope.POS

    if id? and $scope.POS?.id != id
      $scope.POS = _.findWhere POSList, {id: Number(id)}
    else if name? and $scope.POS?.name != name
      $scope.POS = _.findWhere POSList, {name: name}

    if not angular.isObject($scope.POS)
      error = MessagingService.createMessage("error", "POS '#{name}' does not exist for the selected venue", 'CPRReport')
      MessagingService.resetMessages()
      MessagingService.addMessage(error)
      MessagingService.hasMessages('CPRReport')

      return true
    else
      return $scope.POS

  $scope.getVenue = (id, name) ->
    venue = null
    if id?
      venue = _.findWhere venues, {id: Number(id)}
    else if name?
      venue = _.findWhere venues, {name: name}

    return venue

  $scope.formatPercentage = (value) ->
    numeral(value).format('0.000%')

  $scope.calculatePayments = ->
    $scope.report.calculated = {}
    $scope.report.calculated.paymentTotal = Number($scope.report.cashPayment) + Number($scope.report.cardPayment)

    # Cash Payments
    $scope.report.calculated.cashPaymentDifference = Number($scope.report.cashPaymentActual) - Number($scope.report.cashPayment)

    if $scope.report.cashPayment > 0
      $scope.report.calculated.cashPaymentPercentageDifference = $scope.report.calculated.cashPaymentDifference / $scope.report.cashPayment

    # Card Payments
    $scope.report.calculated.cardPaymentDifference = Number($scope.report.cardPaymentActual) - Number($scope.report.cardPayment)

    if $scope.report.cardPayment > 0
      $scope.report.calculated.cardPaymentPercentageDifference = $scope.report.calculated.cardPaymentDifference / $scope.report.cardPayment

    # Payments Total
    $scope.report.calculated.actualPaymentTotal = Number($scope.report.cashPaymentActual) + Number($scope.report.cardPaymentActual)
    $scope.report.calculated.paymentDifferenceTotal = Number($scope.report.calculated.actualPaymentTotal) - Number($scope.report.calculated.paymentTotal)

    if $scope.report.calculated.paymentTotal
      $scope.report.calculated.paymentPercentageDifference = $scope.report.calculated.paymentDifferenceTotal / $scope.report.calculated.paymentTotal

    # Cash Drawer
    $scope.report.calculated.cashDrawerBalance = Number($scope.report.openingBalance) + Number($scope.report.paymentIn) - Number($scope.report.paymentOut) + Number($scope.report.calculated.paymentTotal)
    $scope.report.calculated.cashDrawerActual = Number($scope.report.openingBalance) + Number($scope.report.paymentIn) - Number($scope.report.paymentOut) + Number($scope.report.calculated.actualPaymentTotal)
    $scope.report.calculated.cashDrawerDifference = Number($scope.report.calculated.cashDrawerActual) - Number($scope.report.calculated.cashDrawerBalance)

    if $scope.report.calculated.cashDrawerBalance > 0
      $scope.report.calculated.cashDrawerPercentageDifference = $scope.report.calculated.cashDrawerDifference / $scope.report.calculated.cashDrawerActual

  $scope.$watch "openingDate", ->
    if $scope.openingDate
      $scope.opening.value(kendo.parseDate($scope.openingDate.toISOString())) if $scope.opening

  $scope.$watch "closingDate", ->
    if $scope.closingDate
      $scope.closing.value(kendo.parseDate($scope.closingDate.toISOString())) if $scope.closing

  $scope.$watch "POS", ->
    if $scope.POS? and angular.isNumber parseInt($scope.POS.id)
      $('#posId').data("kendoDropDownList").value($scope.POS.id) if $('#posId').data("kendoDropDownList")

  $scope.generateReport = (reportId) ->
    data = {}
    $scope.readonly = false

    if angular.isDefined reportId and angular.isNumber parseInt(reportId)
      $scope.readonly = true

      ReportsService.getSavedCPR($scope.venueId, reportId).then((response)->
        data = response
        $scope.POS = $scope.getPOS(null, response.pos)
        $scope.posId = $scope.POS?.id ? POSList[0].id

        if data?
          $scope.setDatePickers(data.opening, data.closing)

          data.paymentIn = parseFloat(data.paymentIn ? 0 ).toFixed(2)
          data.paymentOut = parseFloat(data.paymentOut ? 0 ).toFixed(2)
          data.cashPayment = parseFloat(data.cashPayment ? 0 ).toFixed(2)
          data.cashPaymentActual = parseFloat(data.cashPaymentActual ? data.cashPayment ).toFixed(2)
          data.cardPayment = parseFloat(data.cardPayment ? 0 ).toFixed(2)
          data.cardPaymentActual = parseFloat(data.cardPaymentActual ? data.cardPayment ).toFixed(2)
          data.openingBalance = parseFloat(data.openingBalance ? 0 ).toFixed(2)
          data.cashDrawerActual = parseFloat(data.cashDrawerActual ? 0 ).toFixed(2)

          $scope.report = data

          $scope.closing.enable(!$scope.readOnly())

          $scope.calculatePayments()

          $('#venue').data("kendoDropDownList").enable(false)
          $('#posId').data("kendoDropDownList").enable(false)

          $scope.opening.enable(false)
          $scope.closing.enable(!$scope.readOnly())

          $scope.calculatePayments()
      )
    else

      if angular.isNumber(parseInt($scope.POS?.id))

        params = {
          pos: $scope.POS.name
        }

#          opening: JSON.stringify($scope.openingDate).replace(/"/g, '') if angular.isDate($scope.openingDate)
        if $scope.openingDate?
          params.opening = $scope.openingDate.toISOString()

        if $scope.closingDate?
          params.closing = $scope.closingDate.toISOString()

        POSService.getPosValues($scope.venueId, params).then((response) ->
          data = response

          if data?
            $scope.setDatePickers(data.opening, data.closing)

            data.paymentIn = parseFloat(data.paymentIn ? 0 ).toFixed(2)
            data.paymentOut = parseFloat(data.paymentOut ? 0 ).toFixed(2)
            data.cashPayment = parseFloat(data.cashPayment ? 0 ).toFixed(2)
            data.cashPaymentActual = parseFloat(data.cashPaymentActual ? data.cashPayment ).toFixed(2)
            data.cardPayment = parseFloat(data.cardPayment ? 0 ).toFixed(2)
            data.cardPaymentActual = parseFloat(data.cardPaymentActual ? data.cardPayment ).toFixed(2)
            data.openingBalance = parseFloat(data.openingBalance ? 0 ).toFixed(2)
            data.cashDrawerActual = parseFloat(data.cashDrawerActual ? 0 ).toFixed(2)

            $scope.report = data

            $scope.closing.enable(!$scope.readOnly())

            $scope.calculatePayments()
        )

  $scope.openingChange = ->
    $scope.openingDate = moment($scope.opening.value())
    $scope.closingDate = moment($scope.closing.value())

    $scope.$apply ->
      if $scope.openingDate
        $scope.closing.min $scope.openingDate.toISOString()
      else if $scope.closingDate
        $scope.opening.max moment($scope.closingDate)
      else
        $scope.closingDate = moment()
        $scope.opening.max $scope.closingDate
        $scope.closing.min $scope.closingDate
        $scope.closing.max $scope.closingDate

      $scope.generateReport()
      return

  $scope.closingChange = ->
    $scope.closingDate = moment($scope.closing.value())
    $scope.openingDate = moment($scope.opening.value())

    $scope.$apply ->
      if $scope.closingDate
        $scope.opening.max $scope.closingDate.toISOString()
      else if $scope.openingDate
        $scope.closing.min moment($scope.openingDate)
      else
        $scope.closingDate = moment()
        $scope.opening.max $scope.closingDate
        $scope.closing.min $scope.closingDate
        $scope.closing.max $scope.closingDate

      $scope.generateReport()
      return

  $scope.save = ->
    $scope.report.opening = new Date($scope.opening.value())
    $scope.report.closing = new Date($scope.closing.value())
    $scope.report.openingBalance = 0 unless $scope.report.openingBalance

    ReportsService.saveCPR($scope.report).then((response)->
      window.location.href = '#' + $rootScope.backUrl
      location.reload()
    )

#  $scope.convertImgToBase64 = (url, callback, outputFormat) ->
#    canvas = document.createElement("CANVAS")
#    ctx = canvas.getContext("2d")
#    img = new Image
#    img.crossOrigin = "Anonymous"
#    img.onload = ->
#      dataURL = undefined
#      canvas.height = img.height
#      canvas.width = img.width
#      ctx.drawImage img, 0, 0
#      dataURL = canvas.toDataURL(outputFormat)
#      callback.call this, dataURL
#      canvas = null
#      return
#
#    img.src = url
#  return

  $scope.generatePDF = ->

#    $scope.convertImgToBase64('/images/myCircle-Logo.png', (image) ->
#        console.log image
#      , "image/png"
#    )

    docDefinition = {
      content: [
#        {
#          image: getImageDataURL('images/myCircle-Logo.png')
#        }
        {
          columns:
            [
              {
                text: "Closing POS Report"
                style: "headerBar"
                margin: [0, 0, 0, 10]
              }
            ]
        }
        {
          columns:
            [
              {text: "Venue:", width: 200, style: "headerCol", width: 100}
              {text: $scope.venue.name, alignment: "right"}
            ]
        }
        {
          columns:
            [
              {text: "POS:", width: 200, style: "headerCol", width: 100}
              {text: $scope.report.pos, alignment: "right"}
            ]
        }
        {
          columns:
            [
              {text: "Opening:", width: 200, style: "headerCol", width: 100}
              {text: kendo.toString(new Date(kendo.parseDate($scope.report.opening)), 'dddd dd MMM yyyy @ HH:mm'), alignment: "right"}
            ]
        }
        {
          columns:
            [
              {text: "Closing:", width: 200, style: "headerCol", width: 100}
              {text: kendo.toString(new Date(kendo.parseDate($scope.report.closing)), 'dddd dd MMM yyyy @ HH:mm'), alignment: "right"}
            ]
        }
        {
          columns:
            [
              {
                text: "Sales"
                style: "headerBar"
                margin: [0, 20, 0, 10]
              }
            ]
        }
        {
          columns:
            [
              {text: '', width: 100}
              {text: "Payments", width: "*", style: "headerCol"}
              {text: "Actual", width: "*", style: "headerCol"}
              {text: "Difference", width: "*", style: "headerCol"}
              {text: "% Difference", width: "*", style: "headerCol"}
            ]
        }
        {
          columns:
            [
              {text: "Cash", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.cashPayment, "£"), width: "*"}
              {text: $filter('currency')($scope.report.cashPaymentActual, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.cashPaymentDifference, "£"), width: "*"}
              {text: $scope.formatPercentage($scope.report.calculated.cashPaymentPercentageDifference), width: "*"}
            ]
        }
        {
          columns:
            [
              {text: "Card", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.cardPayment, "£"), width: "*"}
              {text: $filter('currency')($scope.report.cardPaymentActual, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.cardPaymentDifference, "£"), width: "*"}
              {text: $scope.formatPercentage($scope.report.calculated.cardPaymentPercentageDifference), width: "*"}
            ]
        }
        {
          columns:
            [
              {text: "Total", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.calculated.paymentTotal, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.actualPaymentTotal, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.paymentDifferenceTotal, "£"), width: "*"}
              {text: $scope.formatPercentage($scope.report.calculated.paymentPercentageDifference), width: "*"}
            ]
        }
        {
          columns:
            [
              {
                text: "Payments"
                style: "headerBar"
                margin: [0, 20, 0, 10]
              }
            ]
        }
        {
          columns:
            [
              {text: '', width: 100}
              {text: "Payments", width: "*", style: "headerCol"}
              {text: "Actual", width: "*", style: "headerCol"}
              {text: "Difference", width: "*", style: "headerCol"}
              {text: "% Difference", width: "*", style: "headerCol"}
            ]
        }
        {
          columns:
            [
              {text: "Payments In", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.paymentIn, "£"), width: "*"}
              {text: "-", width: "*"}
              {text: "-", width: "*"}
              {text: "-", width: "*"}
            ]
        }
        {
          columns:
            [
              {text: "Payments Out", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.paymentOut, "£"), width: "*"}
              {text: "-", width: "*"}
              {text: "-", width: "*"}
              {text: "-", width: "*"}
            ]
        }
        {
          columns:
            [
              {
                text: "Totals"
                style: "headerBar"
                margin: [0, 20, 0, 10]
              }
            ]
        }
        {
          columns:
            [
              {text: '', width: 100}
              {text: "Payments", width: "*", style: "headerCol"}
              {text: "Actual", width: "*", style: "headerCol"}
              {text: "Difference", width: "*", style: "headerCol"}
              {text: "% Difference", width: "*", style: "headerCol"}
            ]
        }
        {
          columns:
            [
              {text: "Opening", style: "headerCol", width: 100}
              {text: "-", width: "*"}
              {text: $filter('currency')($scope.report.openingBalance, "£"), width: "*"}
              {text: "-", width: "*"}
              {text: "-", width: "*"}
            ]
        }
        {
          columns:
            [
              {text: "Cash Drawer Balance", style: "headerCol", width: 100}
              {text: $filter('currency')($scope.report.calculated.cashDrawerBalance, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.cashDrawerActual, "£"), width: "*"}
              {text: $filter('currency')($scope.report.calculated.cashDrawerDifference, "£"), width: "*"}
              {text: $scope.formatPercentage($scope.report.calculated.cashDrawerPercentageDifference), width: "*"}
            ]
        }
      ]
      styles: {
        headerBar: {
          fontSize: 18,
          bold: true
          color: '#6b9b8e'
        }
        headerCol: {
          bold: true,
          fontSize: 10
        }
      }
      defaultStyle: {
        columnGap: 20,
        fontSize: 10
      }
    }

    # Now do the VAT and append it to the content
    if $scope.report.vatSummaryDetails
      vatSection = []

      vatSection.push {
          columns:
            [
              {
                text: "Tax"
                style: "headerBar"
                margin: [0, 20, 0, 10]
              }
            ]
        }

      vatSection.push {
        columns:
          [
            {text: '', width: 100}
            {text: "Rate", width: "*", style: "headerCol"}
            {text: "Total Tax value", width: "*", style: "headerCol"}
            {text: "", width: "*", style: "headerCol"}
            {text: "", width: "*", style: "headerCol"}
          ]
        }

      angular.forEach($scope.report.vatSummaryDetails, (value, index) ->
        vatSection.push {
          columns:
            [
              {text: "", width: "*", style: "headerCol", width: 100}
              {text: $filter('percentage')(value.taxRate)}
              {text: $filter('currency')(value.total, "£") , width: "*", style: "headerCol"}
              {text: "-", width: "*", style: "headerCol"}
              {text: "-", width: "*", style: "headerCol"}
            ]
        }
      )

      docDefinition.content.push(vatSection)

    $timeout ->
      pdfMake.createPdf(docDefinition).open()
    , 200

  $rootScope.$on("$viewContentLoaded", ->
    if $route.current.loadedTemplateUrl is 'views/cpr-report.html'

      $timeout ->
        if POSList.length
          if $route.current.params.id
            reportId = $route.current.params.id
          else
            $scope.POSName = POSName ? POSList[0].name
            $scope.POS = $scope.getPOS(null, $scope.POSName)
            $scope.posId = $scope.POS?.id ? POSList[0].id

          $timeout ->
            $scope.generateReport(reportId)
          , 500

        else
          error = MessagingService.createMessage("error", "No POS devices exist for the selected venue", 'CPRReport')
          MessagingService.resetMessages()
          MessagingService.addMessage(error)
          MessagingService.hasMessages('CPRReport')
      , 500
  )

  # SET VALUES

  $scope.venue = venue ? $rootScope.credentials.venue
  $scope.report = report ? {calculated: {}}

  $scope.report.calculated.cashPaymentPercentageDifference = 0
  $scope.report.calculated.cardPaymentPercentageDifference = 0
  $scope.report.calculated.paymentPercentageDifference = 0
  $scope.report.calculated.cashDrawerPercentageDifference = 0

  $scope.venueId = $scope.venue.id ? venue.id

  $scope.POSList = new kendo.data.DataSource({
    data: POSList
  })

  $scope.venues = new kendo.data.DataSource({
    data: venues
  })

#  $scope.setDateValues()

  $timeout ->
    $scope.venueSelect = $('#venue').kendoDropDownList({
      dataTextField: "name"
      dataValueField: "id"
      dataSource: $scope.venues
      select: $scope.updateVenue
      enabled: !$scope.readOnly()
    })

    $scope.posSelect = $('#posId').kendoDropDownList({
      dataTextField: "name"
      dataValueField: "id"
      dataSource: $scope.POSList
      select: $scope.updatePOS
      enabled: !$scope.readOnly()
    })

    $scope.opening = $("#opening").kendoDateTimePicker({
      value: $scope.openingDate,
      change: $scope.openingChange,
      timeFormat: "HH:mm",
      format: "dd/MM/yyyy HH:mm",
      parseFormats: ["dd/MM/yyyy hh:mmtt", "dd/MM/yyyy HH:mm", "dd/MM/yyyy", "HH:mm"]
      interval: '15'
    }).data("kendoDateTimePicker")

    $scope.closing = $("#closing").kendoDateTimePicker({
      value: $scope.closingDate,
      change: $scope.closingChange,
      timeFormat: "HH:mm",
      format: "dd/MM/yyyy HH:mm",
      parseFormats: ["dd/MM/yyyy hh:mmtt", "dd/MM/yyyy HH:mm", "dd/MM/yyyy", "HH:mm"]
      interval: '15'
    }).data("kendoDateTimePicker")

    $scope.openingDate

    $scope.setDatePickers($scope.openingDate, $scope.closingDate)
  , 500
]