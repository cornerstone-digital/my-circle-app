'use strict'

angular.module('smartRegisterApp')
.directive('reportControls', [ ->
    replace: true
    restrict: 'E'
    scope:
      hidePos: '@'
    template: '''\
<nav class="navbar navbar-default navbar-fixed-top report-subnav" role="navigation">
  <form class="navbar-form" name="reportForm" data-ng-submit="update()">
    <div class="container">
      <div class="form-group navbar-left" data-date-range="range" data-disabled="!!event"></div>
    </div>
    <div class="container">
      <div class="form-group navbar-left">
        <select class="form-control input-lg" data-ng-model="event" data-ng-options="event.name for event in events | orderBy:'start':true track by event.id" data-ng-show="showEventList()">
          <option value="">All events</option>
        </select>
        <select class="form-control input-lg"
            data-ng-show="venues.length"
            data-ng-model="venue"
            data-ng-options="venue.name for venue in venues track by venue.id"
            data-ng-disabled="venueIsLockedDown()"
          >
            <option value="">All venues</option>
        </select>
        <select class="form-control input-lg"
          data-ng-model="device"
          data-ng-options="device.label group by device.type for device in deviceList track by device.id"
          data-ng-hide="hidePos"
          data-ng-disabled="!venueSelected()"
         >
          <option value="">All orders</option>
        </select>
      </div>
      <div class="navbar-right">
        <button type="submit" class="btn btn-primary btn-lg" data-loading-button="Updating&hellip;" data-ng-disabled="!isValid()">Update</button>
        <report-print-button/>
      </div>
    </div>
  </form>
</nav>'''
    controller: ['$scope', '$rootScope', '$element', '$location', 'Event','POSService','VenueService','versionCheckService', ($scope, $rootScope, $element, $location, Event, POSService, VenueService, versionCheckService) ->
#    $scope.venues = $rootScope.credentials.venues

      VenueService.getList($rootScope.credentials.merchant.id).then((response) ->
        $scope.venues = response
      )

      if $location.search()['venueId']?
        VenueService.getById($location.search()['venueId']).then((response) ->
          $scope.venue = response
        )



      $scope.venueIsLockedDown = ->
        $location.search()['venueId']?

      # data to feed the select inputs
      $scope.events = []
      Event.query (events) ->
        $scope.events = events

      $scope.populateDeviceList = (posList) ->
        $scope.device = null

        $scope.deviceList = [
          id: 'ALL_POS', label: 'All POS orders'
        ,
          id: 'ALL_POPP', label: 'All POPP orders'
        ]

        for it in posList
          $scope.deviceList.push
            id: it.name
            label: it.name
            type: 'Devices'

        if $location.search()['pos.uuid']?
          pos =
            id: $location.search()['pos.name']
            label: $location.search()['pos.name']
            type: 'Devices'
          # if the API is not aware of the current POS (i.e. it's never made an order) add it to the list
          $scope.deviceList.push pos unless pos.id in _.pluck($scope.deviceList, 'id')
          $scope.device = pos


      POSService.getList($scope.venue?.id).then((posList) ->
        $scope.populateDeviceList(posList)
        $scope.update()
      )

      # the report parameters this directive controls
      $scope.range =
        from: null
        to: null
      $scope.device = null
      $scope.event = null

      $scope.venueSelected = ->
        $scope.venue?

      $scope.isValid = ->
        $scope.reportForm.$valid

      $scope.update = ->
        if $scope.isValid()
          params = {}

          if $scope.device?.id is 'ALL_POS'
            params.origin = 'MERCHANT'
          else if $scope.device?.id is 'ALL_POPP'
            params.origin = 'CONSUMER'
          else if $scope.device?
            params.origin = 'MERCHANT'
            params.pos = $scope.device?.id

          if $scope.venue?
            params.venueId = $scope.venue?.id

          if $scope.event?
            params.from = moment($scope.event.ordersAcceptedFrom).format('YYYY-MM-DDTHH:mm')
            params.to = moment($scope.event.finish).format('YYYY-MM-DDTHH:mm')
            params.eventId = $scope.event.id
          else
            params.from = $scope.range?.from?.utc()?.format('YYYY-MM-DDTHH:mm')
            params.to = $scope.range?.to?.utc()?.format('YYYY-MM-DDTHH:mm')

          $scope.$emit 'report:update', params

      $scope.showEventList = ->
        $scope.events.length > 0

      $scope.$watch 'venue', (value) ->
        POSService.getList($scope.venue?.id).then((posList) ->
          $scope.populateDeviceList(posList)
        )
    ]
  ])