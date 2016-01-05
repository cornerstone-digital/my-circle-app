angular.module('smartRegisterApp')
.controller 'SalesTransactionHistoryCtrl', ['$rootScope', '$scope', '$timeout', '$location', '$q', '$http', 'Config', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', ($rootScope, $scope, $timeout, $location, $q, $http, Config, ReportsService, POSService, MessagingService, ValidationService) ->

  rangeFrom = $("#dateRangeFrom").kendoDateTimePicker(
    {
      format: "dd/MM/yyyy HH:MM"
    }
  )
  rangeTo = $("#dateRangeTo").kendoDateTimePicker(
    {
      format: "dd/MM/yyyy HH:MM"
    }
  )

  $scope.populateDeviceList = (posList) ->
    $scope.device = null

    $scope.deviceList = [
      id: 'ALL_POS', name: 'All POS'
    ]

    for it in posList
      $scope.deviceList.push
        id: it.name
        name: it.name
        type: 'Devices'

    if $location.search()['pos.uuid']?
      pos =
        id: $location.search()['pos.name']
        label: $location.search()['pos.name']
        type: 'Devices'
      # if the API is not aware of the current POS (i.e. it's never made an order) add it to the list
      $scope.deviceList.push pos unless pos.id in _.pluck($scope.deviceList, 'id')
      $scope.device = pos

    $scope.POSList = new kendo.data.DataSource({
      data: $scope.deviceList
    })

  POSService.getList().then((response) ->
    $scope.populateDeviceList(response)
  )

  $scope.updatePOS = (e) ->
    dataItem = this.dataItem(e.item.index())
    $scope.posId = dataItem.id
    $scope.POS = dataItem
    condition =
      logic: "and"
      filters: []

    if $scope.POS.name != 'All POS'
      condition.filters.push
        field: "pos"
        operator: "eq"
        value: $scope.POS.name

    orderHistoryGrid.data('kendoGrid').dataSource.filter condition
    return

  $scope.resetDateRange = ->
    condition =
      logic: "and"
      filters: []

    rangeFrom.data("kendoDateTimePicker").value(null)
    rangeTo.data("kendoDateTimePicker").value(null)
    orderHistoryGrid.data('kendoGrid').dataSource.filter condition

#    rangeTo.data("kendoDateTimePicker").setDate('')

  $scope.showDetails = (e) ->
    e.preventDefault()
    dataRow = $(e.currentTarget).closest("tr")
    nextRow = dataRow.next('tr')

    if nextRow.hasClass('k-detail-row') && nextRow.filter(":visible").length
      dataRow.find('.k-grid-ShowItems').text('Show Items')
      this.collapseRow($(e.currentTarget).closest("tr"))
    else
      dataRow.find('.k-grid-ShowItems').text('Hide Items')
      this.expandRow($(e.currentTarget).closest("tr"))


  $scope.detailInit = (e) ->
    detailRow = e.detailRow
    itemTable = detailRow.find('.order-items table')
    items = e.data.basket.items
    transactions = e.data.transactions
    orderTotal = 0
    refundAmount = 0

    groupByState = _.groupBy items, (item) ->
      return item.state.toLowerCase()

    angular.forEach items, (value, index) ->
      orderTotal = orderTotal + value.total

      if value.state == 'REFUNDED'
        refundAmount = refundAmount + value.total

      row = angular.element '<tr class="state-' + value.state.toLowerCase() + '"></tr>'
      row.append('<td>' + value.title + '</td>')
      row.append('<td> &pound;' + parseFloat(value.total ? 0 ).toFixed(2) + '</td>')
      row.append('<td class="state-cell">' + value.state + '</td>')

      itemTable.append(row)

  #    itemTable.kendoGrid()

    if transactions.length
      detailRow.find(".order-transactions").kendoGrid({
        dataSource: {
          data: transactions
        }
        # created, type, payment type (as "Payment") and pos (as POS)
        columns: [
          {
            field: "created"
            title: "Date"
            width: "250px"
            template: '#= kendo.toString(kendo.parseDate(created), "HH:mm - dd / MMMM / yyyy" ) #'
          }
          {
            field: "type"
            title: "Type"
          }
          {
            field: "paymentType"
            title: "Payment"
          }
          {
            field: "pos"
            title: "POS"
          }
          {
            field: "amount"
            title: "Amount"
            template: '&pound;#= parseFloat(amount).toFixed(2) #'
            width: "100px   "
          }
        ]
      })

    finalTotal = orderTotal - refundAmount

    detailRow.find('.refunded-count span').text(groupByState.refunded?.length ? 0)
    detailRow.find('.paid-count span').text(groupByState.paid?.length ? 0)
    detailRow.find('.order-total span').text('£' + parseFloat(finalTotal ? 0).toFixed(2))

    detailRow.find(".tabstrip").kendoTabStrip animation:
      open:
        effects: "fadeIn"

    return

  orderHistoryGrid = $(".order-history-list").kendoGrid({
    sortable: true
    filterable: true
    columnMenu: true
    pageable: {
      buttonCount: 5
      pageSize: 15
      refresh: true
    }
    dataSource: {
      serverPaging: true
      serverSorting: true
      serverFiltering: true
      transport: {
        read: (options) ->
          ReportsService.getPagedOrderList($rootScope.credentials.venue.id, options).then((response) ->
            options.success(response)
          )
      }
      schema: {
        model: {
          fields: {
            dateCreated: { type: "date" }
            pos: { type: "string" }
            orderId: { type: "string" }
          }
        }
        total: (response) ->
          return response.page.totalElements

      }
    }
    columns: [
      {
        field: "created"
        title: "Date"
        width: "250px"
        template: '#= kendo.toString(kendo.parseDate(created), "HH:mm - dd / MMMM / yyyy" ) #'
        filterable: false
      }
      {
        field: "pos"
        title: "POS"
        filterable: {
          extra: false
          operators: {
            string: {
              eq: "Is equal to"
            }
          }
          cell: {
            operator: "eq"
          }
        }
      }
      {
        field: "orderId"
        title: "Order ID"
        width: "140px"
        filterable: {
          extra: false
          operators: {
            string: {
              eq: "Is equal to"
            }
          }
          cell: {
            operator: "eq"
          }
        }
      }
      {
        field: "orderTotal"
        title: "Total"
        template: '&pound;#= parseFloat(orderTotal).toFixed(2) #'
        width: "100px"
        sortable: false
        filterable: false
      }
      {
        command: {
          text: "Show Items"
          click: $scope.showDetails
        }
        title: " "
        width: "120px"
      }
    ]
    detailTemplate: kendo.template($("#detail-template").html())
    detailInit: $scope.detailInit
    dataBound: (e) ->
      dataRow = this.tbody.find("tr.k-master-row").first()
      dataRow.find('.k-grid-ShowItems').text('Hide Items')

      this.expandRow(this.tbody.find("tr.k-master-row").first())


      filter = @dataSource.filter()
      @thead.find(".k-header-column-menu.k-state-active").removeClass "k-state-active"
      if filter
        filteredMembers = {}
        setFilteredMembers filter, filteredMembers
        @thead.find("th[data-field]").each ->
          cell = $(this)
          filtered = filteredMembers[cell.data("field")]
          cell.find(".k-header-column-menu").addClass "k-state-active"  if filtered
          return

      return
  })

  orderHistoryGrid.data('kendoGrid').dataSource.read()

  $timeout ->
    $("#POSList").kendoDropDownList({
      dataTextField: "name"
      dataValueField: "id"
      dataSource: $scope.POSList
      select: $scope.updatePOS
    })
  , 500

  $("#dateRangeFrom, #dateRangeTo").on "change", ->
    mindate = $("#dateRangeFrom").data("kendoDateTimePicker").value()
    maxdate = $("#dateRangeTo").data("kendoDateTimePicker").value()

    condition =
      logic: "and"
      filters: []

    if mindate isnt null
      condition.filters.push
        field: "from"
        operator: "ge"
        value: moment(kendo.parseDate(mindate)).format('YYYY-MM-DDTHH:mm')

    if maxdate isnt null
      condition.filters.push
        field: "to"
        operator: "le"
        value: moment(kendo.parseDate(maxdate)).format('YYYY-MM-DDTHH:mm')

    orderHistoryGrid.data('kendoGrid').dataSource.filter condition
    return

  $('#POSList').on "change", ->


  setFilteredMembers = (filter, members) ->
    if filter.filters
      i = 0

      while i < filter.filters.length
        setFilteredMembers filter.filters[i], members
        i++
    else
      members[filter.field] = true
    return
]