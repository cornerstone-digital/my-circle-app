'use strict';

angular.module('smartRegisterApp')
  .factory 'Report', ['$resource', 'Config', 'Auth', '$filter', ($resource, Config, Auth, $filter) ->
    Report = $resource "api://api/merchants/:merchantId/venues/:venueId/reports",
      merchantId: -> Auth.getMerchant()?.id
      venueId: -> Auth.getVenue()?.id
    ,
      get:
        method: 'GET'
        transformResponse: (data, getHeader) ->
          json = if typeof data is 'string' then JSON.parse(data) else data
          dateHeader = getHeader('Date')
          json.created = if dateHeader? then new Date(dateHeader) else new Date()
          json

    Report::totalTax = ->
      memo = 0
      _.forEach @vatReport.vatSummary, (vatSummary) ->
        _.forEach vatSummary.vatSummaryDetails, (it) ->
          memo += if it.type is 'PAYMENT' then it.total else -it.total
      return memo

    Report::totalGross = ->
      _.reduce @zReport.summary, (memo, it) ->
        memo + if it.type is 'PAYMENT' then it.total else -it.total
      , 0

    Report::totalSales = ->
      _.reduce @zReport.summary, (memo, it) ->
        memo + if it.type is 'PAYMENT' then it.total else 0
      , 0

    Report::totalRefunds = ->
      _.reduce @zReport.summary, (memo, it) ->
        memo + if it.type is 'REFUND' then it.total else 0
      , 0

    Report::refundCount = ->
      _.reduce @zReport.summary, (memo, it) ->
        memo + if it.type is 'REFUND' then it.count else 0
      , 0

    Report::cashIn = ->
      value = _.reduce @zReport.summary, (memo, it) ->
        memo + if it.paymentType is 'CASH' and it.type is 'PAYMENT' then it.total else 0
      , 0
      value = _.reduce @paymentReport.payments, (memo, it) ->
        memo + if it.paymentType is 'CASH' and it.direction is 'IN' then it.total else 0
      , value
      return value

    Report::cashOut = ->
      value = _.reduce @zReport.summary, (memo, it) ->
        memo + if it.paymentType is 'CASH' and it.type is 'REFUND' then it.total else 0
      , 0
      value = _.reduce @paymentReport.payments, (memo, it) ->
        memo + if it.paymentType is 'CASH' and it.direction is 'OUT' then it.total else 0
      , value
      return value

    Report::closingTotal = ->
      parseFloat(@openingTotal ? '0') + @cashIn() - @cashOut()

    ###
    A function that can collate PAYMENT and REFUND objects into a single view per
    category or product
    ###
    collate = (items, groupBy) ->
      result = []

      for item in items
        element = result.filter((it) -> it[groupBy] is item[groupBy])[0]
        unless element?
          element =
            net: 0
          element[groupBy] = item[groupBy]
          element[type] = {total: 0, count: 0} for type in ['payment', 'refund']
          result.push element

        element[item.type.toLowerCase()].total += item.total
        element[item.type.toLowerCase()].count += item.count

        if item.type is 'PAYMENT'
          element.net += item.total
        else
          element.net -= item.total

      # return results sorted in descending order of highest grossing
      _.sortBy result, (it) -> -it.payment.total

    Report::byCategory = ->
      unless @_byCategory?
        @_byCategory = collate @categoryReport?.categories ? [], 'category'
      @_byCategory

    Report::byProduct = ->
      unless @_byProduct?
        @_byProduct = collate(@productReport?.products ? [], 'title')
      @_byProduct

    Report::topByProduct = ->
      unless @_topByProduct?
        @_topByProduct = $filter('limitTo') @byProduct(), 10
      @_topByProduct

    Report::byPaymentType = (paymentType, transactionType) ->
      data = @zReport.summary.filter (it) ->
        it.paymentType is paymentType and it.type is transactionType

      if data.length is 0 then null else data[0]

    Report
  ]
