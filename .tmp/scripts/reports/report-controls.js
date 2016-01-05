(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').directive('reportControls', [
    function() {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          hidePos: '@'
        },
        template: '<nav class="navbar navbar-default navbar-fixed-top report-subnav" role="navigation">\n  <form class="navbar-form" name="reportForm" data-ng-submit="update()">\n    <div class="container">\n      <div class="form-group navbar-left" data-date-range="range" data-disabled="!!event"></div>\n    </div>\n    <div class="container">\n      <div class="form-group navbar-left">\n        <select class="form-control input-lg" data-ng-model="event" data-ng-options="event.name for event in events | orderBy:\'start\':true track by event.id" data-ng-show="showEventList()">\n          <option value="">All events</option>\n        </select>\n        <select class="form-control input-lg"\n            data-ng-show="venues.length"\n            data-ng-model="venue"\n            data-ng-options="venue.name for venue in venues track by venue.id"\n            data-ng-disabled="venueIsLockedDown()"\n          >\n            <option value="">All venues</option>\n        </select>\n        <select class="form-control input-lg"\n          data-ng-model="device"\n          data-ng-options="device.label group by device.type for device in deviceList track by device.id"\n          data-ng-hide="hidePos"\n          data-ng-disabled="!venueSelected()"\n         >\n          <option value="">All orders</option>\n        </select>\n      </div>\n      <div class="navbar-right">\n        <button type="submit" class="btn btn-primary btn-lg" data-loading-button="Updating&hellip;" data-ng-disabled="!isValid()">Update</button>\n        <report-print-button/>\n      </div>\n    </div>\n  </form>\n</nav>',
        controller: [
          '$scope', '$rootScope', '$element', '$location', 'Event', 'POSService', 'VenueService', 'versionCheckService', function($scope, $rootScope, $element, $location, Event, POSService, VenueService, versionCheckService) {
            var _ref;
            VenueService.getList($rootScope.credentials.merchant.id).then(function(response) {
              return $scope.venues = response;
            });
            if ($location.search()['venueId'] != null) {
              VenueService.getById($location.search()['venueId']).then(function(response) {
                return $scope.venue = response;
              });
            }
            $scope.venueIsLockedDown = function() {
              return $location.search()['venueId'] != null;
            };
            $scope.events = [];
            Event.query(function(events) {
              return $scope.events = events;
            });
            $scope.populateDeviceList = function(posList) {
              var it, pos, _i, _len, _ref;
              $scope.device = null;
              $scope.deviceList = [
                {
                  id: 'ALL_POS',
                  label: 'All POS orders'
                }, {
                  id: 'ALL_POPP',
                  label: 'All POPP orders'
                }
              ];
              for (_i = 0, _len = posList.length; _i < _len; _i++) {
                it = posList[_i];
                $scope.deviceList.push({
                  id: it.name,
                  label: it.name,
                  type: 'Devices'
                });
              }
              if ($location.search()['pos.uuid'] != null) {
                pos = {
                  id: $location.search()['pos.name'],
                  label: $location.search()['pos.name'],
                  type: 'Devices'
                };
                if (_ref = pos.id, __indexOf.call(_.pluck($scope.deviceList, 'id'), _ref) < 0) {
                  $scope.deviceList.push(pos);
                }
                return $scope.device = pos;
              }
            };
            POSService.getList((_ref = $scope.venue) != null ? _ref.id : void 0).then(function(posList) {
              $scope.populateDeviceList(posList);
              return $scope.update();
            });
            $scope.range = {
              from: null,
              to: null
            };
            $scope.device = null;
            $scope.event = null;
            $scope.venueSelected = function() {
              return $scope.venue != null;
            };
            $scope.isValid = function() {
              return $scope.reportForm.$valid;
            };
            $scope.update = function() {
              var params, _ref1, _ref10, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
              if ($scope.isValid()) {
                params = {};
                if (((_ref1 = $scope.device) != null ? _ref1.id : void 0) === 'ALL_POS') {
                  params.origin = 'MERCHANT';
                } else if (((_ref2 = $scope.device) != null ? _ref2.id : void 0) === 'ALL_POPP') {
                  params.origin = 'CONSUMER';
                } else if ($scope.device != null) {
                  params.origin = 'MERCHANT';
                  params.pos = (_ref3 = $scope.device) != null ? _ref3.id : void 0;
                }
                if ($scope.venue != null) {
                  params.venueId = (_ref4 = $scope.venue) != null ? _ref4.id : void 0;
                }
                if ($scope.event != null) {
                  params.from = moment($scope.event.ordersAcceptedFrom).format('YYYY-MM-DDTHH:mm');
                  params.to = moment($scope.event.finish).format('YYYY-MM-DDTHH:mm');
                  params.eventId = $scope.event.id;
                } else {
                  params.from = (_ref5 = $scope.range) != null ? (_ref6 = _ref5.from) != null ? (_ref7 = _ref6.utc()) != null ? _ref7.format('YYYY-MM-DDTHH:mm') : void 0 : void 0 : void 0;
                  params.to = (_ref8 = $scope.range) != null ? (_ref9 = _ref8.to) != null ? (_ref10 = _ref9.utc()) != null ? _ref10.format('YYYY-MM-DDTHH:mm') : void 0 : void 0 : void 0;
                }
                return $scope.$emit('report:update', params);
              }
            };
            $scope.showEventList = function() {
              return $scope.events.length > 0;
            };
            return $scope.$watch('venue', function(value) {
              var _ref1;
              return POSService.getList((_ref1 = $scope.venue) != null ? _ref1.id : void 0).then(function(posList) {
                return $scope.populateDeviceList(posList);
              });
            });
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=report-controls.js.map
