angular.module('smartRegisterApp')
.factory 'ReportsService', ['$rootScope', '$q', '$http', '$timeout', '$route', 'ResourceWithPaging','ResourceNoPaging', 'Auth', 'POSService', 'MessagingService', ($rootScope, $q, $http, $timeout, $route, ResourceWithPaging, ResourceNoPaging, Auth, POSService, MessagingService) ->
  getPagedCPRList: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id

    if(!angular.isObject(params))
      params = {
        page: $route.current.params.page ? null
        size: $route.current.params.size ? null
        sort: $route.current.params.sort ? null
      }

    ResourceWithPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).one("reports").all("cprs").getList(params)

  saveCPR: (reportData) ->
    response = $q.defer()
    apiURL = "api://api/merchants/#{reportData.merchantId}/venues/#{reportData.venueId}/reports/cpr"

    delete reportData.vatSummaryDetails
    delete reportData.calculated
    delete reportData.created
    delete reportData.apiVersion

    $http {
      url: apiURL
      method: 'POST'
      data: reportData
    }
    .success (data, status, headers, config) ->
      response.resolve(data)

      return response.promise
    .error (data, status, headers, config) ->
      error = MessagingService.createMessage("error", data.message, 'CPRReport')
      MessagingService.resetMessages()
      MessagingService.addMessage(error)
      MessagingService.hasMessages('CPRReport')

  getSavedCPR: (venueId, id) ->
    ResourceNoPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).one("reports").one("cprs", id).get()

  getPagedOrderList: (venueId, options) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id

    params = {
      page: options.data.page - 1 ? null
      size: options.data.pageSize ? null
    }

    if options.data?.sort?
      angular.forEach options.data.sort, (item, index) ->
        params.sort = "#{item.field},#{item.dir}"

    if options.data?.filter?
      angular.forEach options.data.filter.filters, (item, index) ->
        params[item.field] = item.value

    ResourceWithPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).all("orders").getList(params).then((response) ->
      angular.forEach response, (value, index) ->
        total = 0

        angular.forEach response[index].basket.items, (value, index) ->
          total = total + value.total

        response[index]["orderTotal"] = parseFloat(total ? 0 ).toFixed(2)
    )
]