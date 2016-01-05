'use strict'

angular.module('smartRegisterApp')
.controller 'VenuesCtrl', ['$rootScope', '$document', '$http', '$location', '$route', '$scope', 'venues', 'Auth', 'VenueService', 'SettingsService','MessagingService', ($rootScope, $document, $http, $location, $route, $scope, venues, Auth, VenueService, SettingsService, MessagingService) ->
#  VenueService.getGridList($rootScope.credentials.merchant.id).then((venues) ->
#    $scope.venues = venues
#  )

  deleteAlert = $('.delete-alert')

  $scope.venues = venues
  $scope.selectedItems = []

  # Employee Grid Setup
  $scope.venuesGridOptions =
    dataSource:
      data: $scope.venues
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
        field: "postcode"
        title: "Postcode"
      }
      {
        field: "email"
        title: "Email"
      }
      {
        field: "phone"
        title: "Phone"
      }
      {
        template: "<button data-kendo-button data-ng-click=\"editVenue(#=id#)\">Edit</button>"
        title: ""
        width: "100px"
      }
    ]

  $scope.singleCheckboxClicked = (e) ->
    row = $("[data-uid='" + e.dataItem.uid + "']")
    cb = row.find("input")

    if (cb.is(':checked'))
      $('input[type="checkbox"').prop("checked", false)
      cb.prop("checked", true)
      $scope.selectedItems.push(e.dataItem.id)
    else
      $scope.selectedItems = []

  $rootScope.errors = {
    venue: []
  }

  $scope.deleteVenues = ->
    if $scope.selectedItems.length
      deleteAlert.hide()

      VenueService.getById($scope.selectedItems[0]).then((venue)->
        VenueService.remove(venue).then((response)->
          VenueService.getGridList().then((venues)->
            $scope.showMessage("Delete Successful")
            $scope.venues = venues
            if $scope.venues.length
              $('#venuesGrid').data("kendoGrid").dataSource.data(venues)
              $scope.selectedItems = []
          )
        )
      )
    else
      deleteAlert.show()

  $scope.getVenueContactByType = (venue, type) ->
    if VenueService.getVenueContactByType(venue, type)?.value?
      VenueService.getVenueContactByType(venue, type)?.value
    else
      null


  $scope.confirmedDelete = (venue) ->
    $scope.venuesToDelete = [venue]

  $scope.closeConfirm = ->
    delete $scope.venuesToDelete

  $scope.confirmYes = ->
    $scope.remove($scope.venuesToDelete[0])

    $scope.closeConfirm()

  $scope.resetChecked = ->
    $('input[type="checkbox"').prop("checked", false)
    $scope.checkedVenues = []

  $scope.resetErrors = ->
    $rootScope.errors.venue = []

  $scope.updateCheckboxStatus = (venue) ->
    $scope.resetChecked()

    venueCheckbox = $('#venueCheckbox' + venue.id)
    venueCheckbox.prop("checked", !venueCheckbox.prop("checked"))

    $scope.checkedVenues.push venue.id

  $scope.showMessage = (messageText) ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("success", messageText, 'Venue')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Venue')

  $scope.create = ->
    $location.path '/venues/add'

  $scope.duplicateVenue = ->
    $scope.resetErrors()

    if $scope.selectedItems.length && $scope.selectedItems.length == 1
      VenueService.getById($scope.selectedItems[0]).then((venue)->
        $scope.duplicate(venue)
      )
    else if $scope.selectedItems.length > 1
      $scope.errors.venue.push("You can only duplicate 1 venue at a time.")
    else if $scope.selectedItems.length == 0
      $scope.errors.venue.push("Please select a venue to duplicate")

  $scope.duplicate = (venue) ->
    $scope.$broadcast 'venue:duplicate', venue

  $scope.editVenue = (venueId) ->
    $location.path "/venues/edit/#{venueId}"

  $scope.editVenueProducts = (venue) ->
    $scope.$broadcast 'venue:editProducts', venue

  $scope.remove = (venue) ->
    VenueService.remove(venue).then( ->
        VenueService.getList().then((venues) ->
          $scope.venues = venues
        )
      , ->
        console.error "could not delete", venue
        $scope.$broadcast "delete:failed", venue
    )

  $scope.hasErrors = ->
    if angular.isDefined $rootScope.errors
      return true
    else
      return false

  $scope.hasMultipleVenues = ->
    if $scope.venues?
      if $scope.venues.length > 1
        return true
      else
        return false

  $scope.canAddVenue = ->
    VenueService.canAddVenue()

  $scope.canDuplicateVenues = ->
    Auth.hasRole 'PERM_MERCHANT_ADMINISTRATOR'

  $scope.canDeleteVenues = ->
    if Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR') && $scope.hasMultipleVenues()
      return true
    else
      return false

  $scope.$on 'delete:succeeded', ->
    $route.reload()

  $scope.$on 'delete:requested', (event, venue) ->
    $scope.delete venue

  $scope.$on 'venue:saved', (event, response) ->
    VenueService.getList().then (response) ->
      $scope.venues = response

  $scope.$on 'venue:created', (event, venue) ->
    $scope.venues.push venue

  $scope.$on 'venue:updated', (event, venue) ->
    for index in [0...$scope.venues.length]
      $scope.venues[index] = angular.copy(venue) if $scope.venues[index].id is venue.id

  $scope.$on 'venue:editProducts', (event, venue) ->
    $rootScope.credentials.venue = angular.copy(venue)
    $scope.productsForCategory = $scope.products

    $location.path '/products'

  $scope.$on 'venue:duplicate', (event, venue) ->
    VenueService.getById(venue.id,{full:true}).then((fullVenue)->
      VenueService.duplicate(fullVenue).then((duplicateVenue)->
        $scope.$broadcast 'venue:created', duplicateVenue
        VenueService.getGridList().then((venues)->
          $scope.venues = venues
          if $scope.venues.length
            $('#venuesGrid').data("kendoGrid").dataSource.data(venues)
            $scope.selectedItems = []
            $scope.showMessage "Duplication Successful"
        )
      )
    )
]
