'use strict'

angular.module('smartRegisterApp')
.controller 'VenueFormCtrl', ['$rootScope','$scope','$location','$timeout', 'Config','venue','employees','discounts','VenueService','EmployeeService','DiscountService','MessagingService','ValidationService', ($rootScope,$scope,$location,$timeout,Config,venue,employees,discounts,VenueService,EmployeeService,DiscountService,MessagingService,ValidationService) ->
  $scope.venue = venue
  $scope.employees = employees
  $scope.discounts = discounts
  saveBtn = $('.save-btn')
  addStaffBtn = $('.add-staff-btn')
  deleteStaffBtn = $('.delete-staff-btn')
  addDiscountBtn = $('.add-discount-btn')
  deleteDiscountBtn = $('.delete-discount-btn')
  cancelSaveBtn = $('.cancel-save-btn')
  cancelBtn = $('.cancel-btn')
  deleteAlert = $('.delete-alert')
  saveAlert = $('.save-alert')
  venueEmployeesGrid = $('#venueEmployeesGrid')
  venueDiscountsGrid = $('#venueDiscountsGrid')
  $scope.selectedItems = []

  saveBtn.show()
  addStaffBtn.hide()
  deleteStaffBtn.hide()
  addDiscountBtn.hide()
  deleteDiscountBtn.hide()

  $scope.cancelBtnClick = ->
    saveAlert.hide()
    console.log "cancel btn clicked"

  $scope.cancelSaveBtnClick = ->
    $scope.safeApply ->
      $scope.dataChanged = false
      saveAlert.hide()
      window.location = $scope.nextURL



    return
#    location.reload()

  $scope.onSelect = (e) ->
    tabText = $(e.item).find("> .k-link").text()
    deleteAlert.hide()
    saveAlert.hide()

    if tabText == 'Venue'
      saveBtn.show()
      addStaffBtn.hide()
      deleteStaffBtn.hide()
      addDiscountBtn.hide()
      deleteDiscountBtn.hide()

    if tabText == 'Staff'
      saveBtn.hide()
      addStaffBtn.show()
      deleteStaffBtn.show()
      addDiscountBtn.hide()
      deleteDiscountBtn.hide()

    if tabText == 'Discounts'
      saveBtn.hide()
      addStaffBtn.hide()
      deleteStaffBtn.hide()
      addDiscountBtn.show()
      deleteDiscountBtn.show()

    return

  unless $scope.venue.contacts
    $scope.venue.contacts = []

  $scope.countries = [
    {id:232, numericCode: 826, name: 'United Kingdom'}
    {id:233, numericCode: 840, name: 'United States'}
  ]

  $scope.name = VenueService.getVenueContactByType(venue, 'NAME') ? {}
  $scope.phone = VenueService.getVenueContactByType(venue, 'PHONE') ? {}
  $scope.email = VenueService.getVenueContactByType(venue, 'EMAIL') ? {}

  $scope.venue.sections = $scope.venue.sections ? []

  # Employee Grid Setup
  $scope.employeeGridOptions =
    dataSource:
      data: $scope.employees
      pageSize: 10
      serverPaging: false
      serverSorting: false

    sortable: true
    pageable: true

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
        field: "active"
        title: "Active"
      }
      {
        template: "<button data-kendo-button data-ng-click=\"editEmployee(#=id#)\">Edit</button>"
        title: ""
        width: "100px"
      }
    ]

  # Discount Grid Setup
  $scope.discountGridOptions =
    dataSource:
      data: $scope.discounts
      pageSize: 10
      serverPaging: false
      serverSorting: false

    sortable: true
    pageable: true

    columns: [
      {
        field: "check_row"
        title: " "
        width: 30
        template: "<input data-ng-click='singleCheckboxClicked(this)' class='check_row' type='checkbox' />"
        filterable: false
      }
      {
        field: "name"
        title: "Name"
      }
      {
        field: "value"
        title: "Value"
        template: "#=value * 100#\\%"
      }
      {
        template: "<button data-kendo-button data-ng-click=\"editDiscount(#=id#)\">Edit</button>"
        title: ""
        width: "100px"
      }
    ]

  $scope.resetChecked = ->
    $('input[type="checkbox"').prop("checked", false)
    $scope.selectedItems = []

  $scope.checkboxClicked = (e) ->
    row = $("[data-uid='" + e.dataItem.uid + "']")
    cb = row.find("input")

    if (cb.is(':checked'))
      $scope.selectedItems.push(e.dataItem.id)
    else
      $scope.selectedItems = _.without($scope.selectedItems, e.dataItem.id)

  $scope.singleCheckboxClicked = (e) ->
    row = $("[data-uid='" + e.dataItem.uid + "']")
    cb = row.find("input")

    if (cb.is(':checked'))
      $('input[type="checkbox"').prop("checked", false)
      cb.prop("checked", true)
      $scope.selectedItems.push(e.dataItem.id)
    else
      $scope.selectedItems = []

  $scope.editEmployee = (employeeId) ->
    $location.path "venues/#{venue.id}/employees/edit/#{employeeId}"

  $scope.editDiscount = (discountId) ->
    $location.path "discounts/edit/#{discountId}"

  $scope.addEmployee = ->
    $location.path "venues/#{venue.id}/employees/add"

  $scope.deleteEmployees = ->
    if $scope.selectedItems.length
      deleteAlert.hide()

      EmployeeService.bulkDeleteVenueEmployees($scope.selectedItems, venue.id).then((response)->


        EmployeeService.getGridListByVenue(venue).then((employees)->
          $scope.showMessage("Delete Successful")
          $scope.employees = employees
          if $scope.employees.length
            $('#venueEmployeesGrid').data("kendoGrid").dataSource.data(employees)
        )
      )
    else
      deleteAlert.show()

  $scope.addDiscount = ->
    $location.path "discounts/add"

  $scope.deleteDiscounts = ->
    if $scope.selectedItems.length
      deleteAlert.hide()
      angular.forEach $scope.selectedItems, (id, index) ->
        DiscountService.getById(id).then((discount) ->
          DiscountService.remove(discount).then((response)->
            DiscountService.getList().then((discounts)->
              $scope.showMessage("Delete Successful")
              $scope.discounts = discounts
              if $scope.discounts.length
                $('#venueDiscountsGrid').data("kendoGrid").dataSource.data(discounts)
            )
          )
        )
    else
      deleteAlert.css("right", "305px")
      deleteAlert.show()


  $scope.updateVenueCountry = ->
    $scope.venue.address.country = {
      numericCode: $scope.venue.address.country.numericCode
    }

  $scope.addSection = (section, $event) ->
    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Sections')

    # Now check for duplicates
    if(VenueService.isExistingSection($scope.venue, section).length)
      error = MessagingService.createMessage("error", "A section with that name already exists.", 'Sections')
      MessagingService.addMessage(error)

    if(!MessagingService.hasMessages('Sections').length)
      $scope.venue.sections.push {name: section}
#      $scope.$broadcast "section:save", $scope.venue.sections
      delete $scope.newSection
      $scope.showDataChangedMessage()

  $scope.deleteSection = (section) ->
    section = VenueService.getSectionById($scope.venue, section.id)
    index = $scope.venue.sections.indexOf(section)
    $scope.venue.sections.splice index, 1
    $scope.showDataChangedMessage()

  $scope.reset = ->
    MessagingService.resetMessages()
    ValidationService.reset()

    if $scope.venue.id?
      VenueService.getById($scope.venue.id).then((response)->
        $scope.venue = response
      )
    else
      $scope.venue = VenueService.new()

  $scope.showMessage = (messageText) ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("success", messageText, 'Venue')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Venue')

  $scope.showDataChangedMessage = ->
    $scope.dataChanged = true

  $scope.save = (redirect) ->

    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Venue')


    if(!MessagingService.hasMessages('Venue').length)

      hasName = VenueService.getVenueContactByType($scope.venue, 'NAME')
      hasPhone = VenueService.getVenueContactByType($scope.venue, 'PHONE')
      hasEmail = VenueService.getVenueContactByType($scope.venue, 'EMAIL')

      unless hasName
        if $scope.name.value?
          $scope.name.type = 'NAME'
          $scope.venue?.contacts.push $scope.name

      unless hasPhone
        if $scope.phone.value?
          $scope.phone.type = 'PHONE'
          $scope.venue?.contacts.push $scope.phone

      unless hasEmail
        if($scope.email.value?)
          $scope.email.type = 'EMAIL'
          $scope.venue.contacts.push $scope.email

      VenueService.save($scope.venue).then((response) ->
        $scope.locked = false
        $scope.venue = response
        $location.path "/venues"
        $scope.dataChanged = false
        return true
      , (response) ->
        console.error 'update failed'
        $scope.locked = false
      )

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

  $scope.validateEmail = (email) ->

    if email.length and !ValidationService.isEmail(email)
      MessagingService.resetMessages()
      message = MessagingService.createMessage("error", "'#{email}' is not a valid email address.", 'Venue')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('Venue')

  $scope.validatePostcode = (postcode) ->

    if postcode.length and !ValidationService.isPostcode(postcode)
      MessagingService.resetMessages()
      message = MessagingService.createMessage("error", "'#{postcode}' is not a valid postcode.", 'Venue')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('Venue')

  $scope.$on('$locationChangeStart', ( event, next, current) ->

    if $scope.dataChanged
      $scope.nextURL = next
      event.preventDefault()
      saveAlert.show()
  )
]
