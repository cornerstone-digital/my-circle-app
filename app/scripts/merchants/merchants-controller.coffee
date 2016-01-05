'use strict'

angular.module('smartRegisterApp')
.controller 'MerchantsCtrl', ['$scope', '$http', '$location', 'Config', 'Merchant', 'Venue', 'Employee', 'merchants','merchantlist', 'MerchantService', 'SettingsService', ($scope, $http, $location, Config, Merchant, Venue, Employee, merchants, merchantlist, MerchantService, SettingsService) ->

  if(angular.isDefined(merchantlist))
    $scope.merchantlist = merchantlist

  if(angular.isDefined(merchants))
    $scope.merchants = merchants
  else
    params = {
      page: $scope.currentPage - 1 ? null
      size: $scope.maxSize ? null
    }

    MerchantService.getPagedList(params).then (response) ->
      $scope.merchants = response

  if(angular.isDefined($scope.merchants.page))
    $scope.totalItems = $scope.merchants.page.totalElements
    $scope.currentPage = $scope.merchants.page.number + 1
    $scope.itemsPerPage = $scope.merchants.page.size;
    $scope.totalPages = $scope.merchants.page.totalPages

  $scope.setPage = (pageNo) ->
    $scope.currentPage = pageNo;

  $scope.pageChanged = ->
    params = {
      page: $scope.currentPage - 1 ? null
      size: $scope.maxSize ? null
    }

    MerchantService.getPagedList(params).then (response) ->
      $scope.merchants = response

  $scope.sort = 'name'
  $scope.reverse = false

  $scope.create = ->
    $location.path '/merchants/add'

  $scope.delete = (merchant) ->
    MerchantService.getById(merchant.id).then((response) ->
      merchant = response
      MerchantService.remove(merchant).then((response)->
        $scope.merchants = _.reject $scope.merchants, (it) -> it.id is merchant.id
      )
    )


  $scope.edit = (merchant) ->
    $location.path "/merchants/edit/#{merchant.id}"


  $scope.save = ->
    if $scope.merchantForm.$valid

      # create local refs for these values in case the form gets closed before API calls complete
      merchant = $scope.merchant

      $scope.locked = true

      if !merchant?.id && merchant.employees?[0].credentials?[0]
        merchant.employees[0].credentials[0].uid = merchant.employees[0].email

      MerchantService.save(merchant).then((response) ->
        newMerchant = response

        if merchant?.id
          for index in [0...$scope.merchants.length]
            $scope.merchants[index] = angular.copy(merchant) if $scope.merchants[index].id is merchant.id
        else
          $scope.merchants.push newMerchant
          $scope.$root.$broadcast 'merchant:created', newMerchant

        delete $scope.locked
        $scope.close()

      , (response) ->
        console.error "failed to save credential"
        delete $scope.locked
      )

  $scope.close = ->
    delete $scope.merchant
    delete $scope.venue
    delete $scope.employee

  $scope.confirmedDelete = (merchant) ->
    $scope.merchantToDelete = merchant

  $scope.closeConfirm = ->
    delete $scope.merchantToDelete

  $scope.confirmYes = ->
    $scope.delete($scope.merchantToDelete)
    index = $scope.merchants.indexOf($scope.merchantToDelete.id)
    $scope.merchants.splice index, 1

    $scope.closeConfirm()

  $scope.hasModuleEnabled = (moduleName) ->
    SettingsService.hasModuleEnabled moduleName

]
