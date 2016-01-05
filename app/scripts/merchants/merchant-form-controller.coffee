'use strict'

angular.module('smartRegisterApp')
.controller 'MerchantFormCtrl', ['$rootScope', '$scope','$location', '$timeout', '$http', 'merchant', 'venues', 'employees', 'Auth', 'VenueService', 'EmployeeService', 'MerchantService','MessagingService', 'ValidationService', ($rootScope, $scope, $location, $timeout, $http, merchant, venues, employees, Auth, VenueService, EmployeeService, MerchantService, MessagingService, ValidationService) ->
  $scope.merchant = merchant
  $scope.venues = venues
  $scope.employees = employees
  saveBtn = $('.save-btn')
  addStaffBtn = $('.add-staff-btn')
  deleteStaffBtn = $('.delete-staff-btn')
  deleteAlert = $('.delete-alert')
  cancelSaveBtn = $('.cancel-save-btn')
  cancelBtn = $('.cancel-btn')
  deleteAlert = $('.delete-alert')
  saveAlert = $('.save-alert')
  $scope.selectedItems = []

  saveBtn.show()
  addStaffBtn.hide()
  deleteStaffBtn.hide()

  $scope.showMessage = (messageText) ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("success", messageText, 'Venue')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Venue')

  $scope.cancelBtnClick = ->
    saveAlert.hide()
    console.log "cancel btn clicked"

  $scope.cancelSaveBtnClick = ->
    $scope.safeApply ->
#      nextURL = $location.url($scope.nextURL).hash()
      saveAlert.hide()
      $scope.dataChanged = false
      window.location = $scope.nextURL

  $scope.onSelect = (e) ->
    tabText = $(e.item).find("> .k-link").text()

    if tabText == 'Merchant'
      saveBtn.show()
      addStaffBtn.hide()
      deleteStaffBtn.hide()

    if tabText == 'Staff'
      saveBtn.hide()
      addStaffBtn.show()
      deleteStaffBtn.show()

    return


  $scope.countries = [
    {id:232, numericCode: 826, name: 'United Kingdom'}
    {id:233, numericCode: 840, name: 'United States'}
  ]

  employeeDatasource = new kendo.data.DataSource({
    data: $scope.employees
    pageSize: 10
    serverPaging: false
    serverSorting: false
  })

  # Employee Grid Setup
  $scope.employeeGridOptions =
    dataSource: employeeDatasource
    sortable: true
    pageable: true
    filterable: true

    columns: [
      {
        field: "check_row"
        title: " "
        width: 30
        template: "<input data-ng-click='checkboxClicked(this)' class='check_row' type='checkbox' />"
        filterable: false
      }
      {
        field: "firstname"
        title: "First name"
      }
      {
        field: "lastname"
        title: "Last name"
      }
      {
        field: "displayName"
        title: "Display name"
      }
      {
        template: "<input type=\"button\" class=\"icon icon-lg edit-icon ng-scope\" ng-click=\"editEmployee(#=id#)\" data-requires-permission=\"PERM_MERCHANT_ADMINISTRATOR\" value=\"Edit\">"
        title: "Actions"
        width: "70px"
      }
    ]

  $scope.checkboxClicked = (e) ->
    row = $("[data-uid='" + e.dataItem.uid + "']")
    cb = row.find("input")

    if (cb.is(':checked'))
      $scope.selectedItems.push(e.dataItem.id)
    else
      $scope.selectedItems = _.without($scope.selectedItems, e.dataItem.id)

  $scope.addEmployee = ->
    $location.path "employees/add"

  $scope.deleteEmployees = ->
    if $scope.selectedItems.length
      deleteAlert.hide()

      EmployeeService.bulkDeleteMerchantEmployees($scope.selectedItems, merchant.id).then((response)->


        EmployeeService.getGridList().then((employees)->
          $scope.showMessage("Delete Successful")
          $scope.employees = employees
          if $scope.employees.length
            $('#merchantEmployeesGrid').data("kendoGrid").dataSource.data(employees)
        )
      )
    else
      deleteAlert.show()


  $scope.editEmployee = (employeeId) ->
    $location.path "employees/edit/#{employeeId}"

  $scope.editVenue = (venueId) ->
    $location.path "venues/edit/#{venueId}"

  $scope.showMessage = (messageText) ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("success", messageText, 'Merchant')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Merchant')

  $scope.reset = ->
    MessagingService.resetMessages()
    ValidationService.reset()

    if $scope.merchant.id?
      MerchantService.getById($scope.merchant.id).then((response)->
        $scope.merchant = response
      )
    else
      $scope.merchant = MerchantService.new()

  $scope.save = (redirect) ->

    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Merchant')

    if(!MessagingService.hasMessages('Merchant').length)
      $scope.locked = true

      merchant = $scope.merchant

      if !merchant?.id && merchant.employees?[0].credentials?[0]
        merchant.employees[0].credentials[0].uid = merchant.employees[0].email

      MerchantService.save(merchant).then((response) ->
        $scope.showMessage "Save Successful"
        $scope.locked = false
        $scope.merchant = response
        $scope.dataChanged = false
      , (response) ->
        console.error 'update failed'
        $scope.locked = false
      )
    else

  $scope.showDataChangedMessage = ->
    $scope.dataChanged = true

  $scope.findNextElemByTabIndex = (tabIndex) ->
    matchedElement = angular.element( document.querySelector("[tabindex='#{tabIndex}']") )

    return matchedElement

  $scope.moveToNextTabIndex = ($event, $editable) ->
    currentElem = $editable
    nextElem = []

    # Find next available tabIndex
    if currentElem.attrs.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex)

    currentElem.save()
    currentElem.hide()

    if(nextElem.length)
      $timeout ->
        nextElem.click()
      , 10

  $scope.keypressCallback = ($event, $editable) ->
    currentElem = $editable
    nextElem = []

    # Find next available tabIndex
    if currentElem.attrs.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex)

    if $event.which == 9
      $event.preventDefault()
      currentElem.save()
      currentElem.hide()

      if(nextElem.length)
        $timeout ->
          nextElem.click()
        , 10

    if $event.which == 13
      $event.preventDefault()
      currentElem.save()
      currentElem.hide()


  $scope.$on('$locationChangeStart', ( event, next, current) ->

    if $scope.dataChanged
      $scope.nextURL = next
      event.preventDefault()
      saveAlert.show()

  )
]
