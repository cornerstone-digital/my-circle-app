# TODO: Update report-controls.spec
#'use strict'
#
#describe 'Directive: reportControls', ->
#
#  beforeEach module 'mockEnvironment', 'smartRegisterApp'
#
#  $scope = null
#  $element = null
#  $isolateScope = null
#  listener = null
#  events = null
#  posList = null
#
#  beforeEach inject ($rootScope, Event, Pos) ->
#    events = [
#      id: 1
#      name: 'Event 1'
#      start: '2014-03-29T15:00:00Z'
#      finish: '2014-03-29T16:30:00Z'
#      ordersAcceptedFrom: '2014-03-22T09:00:00Z'
#      ordersAcceptedUntil: '2014-03-29T15:00:00Z'
#    ]
#
#    posList = [
#      uuid: '1'
#      name: 'POS 1'
#    ,
#      uuid: '2'
#      name: 'POS 2'
#    ]
#    spyOn(Pos, 'query').andCallFake (callback) ->
#      callback posList.map (it) -> new Pos(it)
#
#    $scope = $rootScope.$new()
#    $element = angular.element '<report-controls></report-controls>'
#
#    listener = jasmine.createSpy()
#    $scope.$on 'report:update', listener
#
#  describe 'rendering the event list', ->
#
#    $select = null
#
#    describe 'when there are no events', ->
#
#      beforeEach inject ($compile, Event) ->
#        spyOn(Event, 'query').andCallFake (callback) ->
#          callback []
#
#        $compile($element) $scope
#
#        $scope.$digest()
#
#        $select = $element.find('select[data-ng-model=event]')
#
#      it 'should not display the event list at all', ->
#        expect($select).toBeHidden()
#
#    describe 'when there are some events', ->
#
#      beforeEach inject ($compile, Event) ->
#        spyOn(Event, 'query').andCallFake (callback) ->
#          callback events.map (it) -> new Event(it)
#
#        $compile($element) $scope
#
#        $isolateScope = $element.isolateScope()
#
#        $scope.$digest()
#
#        $select = $element.find('select[data-ng-model=event]')
#
#      it 'should render an option for each event', ->
#        expect($select.find('option').length).toBe events.length + 1
#        expect($select.find('option:last-child').attr('value')).toBe events[0].id.toString()
#        expect($select.find('option:last-child').text()).toBe events[0].name
#
#      it 'should update the scope when an event is selected', ->
#        expect($isolateScope.event).toBeNull()
#
#        $select.find('option:last-child').prop('selected', true)
#        $select.trigger('change')
#
#        expect($isolateScope.event?.id).toBe events[0].id
#
#  describe 'rendering the device list', ->
#
#    $select = null
#
#    beforeEach inject ($location, $compile, Event) ->
#      spyOn(Event, 'query').andCallFake (callback) ->
#        callback events.map (it) -> new Event(it)
#
#      $compile($element) $scope
#
#      $isolateScope = $element.isolateScope()
#
#      $scope.$digest()
#
#      $select = $element.find('select[data-ng-model=device]')
#
#    it 'should render top level options for order types', ->
#      $options = $select.find('> option')
#      expect($options.length).toBe 3
#      expect(_.map $options, (it) -> $(it).attr('value')).toEqual ['', 'ALL_POS', 'ALL_POPP']
#      expect(_.map $options, (it) -> $(it).text()).toEqual ['All orders', 'All POS orders', 'All POPP orders']
#
#    it 'should render grouped options for each POS', ->
#      $options = $select.find('> optgroup > option')
#      expect($options.length).toBe posList.length
#      expect(_.map $options, (it) -> $(it).attr('value')).toEqual _.pluck posList, 'name'
#      expect(_.map $options, (it) -> $(it).text()).toEqual _.pluck posList, 'name'
#
#  describe 'with a POS id on the query string', ->
#
#    beforeEach inject ($location, $compile, Event) ->
#      spyOn(Event, 'query').andCallFake (callback) ->
#        callback events.map (it) -> new Event(it)
#
#      spyOn($location, 'search').andCallFake ->
#        'pos.uuid': '2'
#        'pos.name': 'POS 2'
#
#      $compile($element) $scope
#
#      $isolateScope = $element.isolateScope()
#      $isolateScope.reportForm =
#        $valid: true
#
#      $scope.$digest()
#
#    it 'selects the specified POS', ->
#      $select = $element.find('select[data-ng-model=device]')
#      expect($select.find('option').length).toBe posList.length + 3
#      expect($select.find('option[selected]').length).toBe 1
#      expect($select.find('option[selected]').attr('value')).toBe 'POS 2'
#
#  describe 'with a POS id on the query string for a POS that is not known to the API', ->
#
#    beforeEach inject ($location, $compile, Event) ->
#      spyOn(Event, 'query').andCallFake (callback) ->
#        callback events.map (it) -> new Event(it)
#
#      spyOn($location, 'search').andCallFake ->
#        'pos.uuid': '3'
#        'pos.name': 'POS 3'
#
#      $compile($element) $scope
#
#      $isolateScope = $element.isolateScope()
#      $isolateScope.reportForm =
#        $valid: true
#
#      $scope.$digest()
#
#    it 'adds an extra option to the POS list', ->
#      $options = $element.find('select[data-ng-model=device] option')
#      expect($options.length).toBe posList.length + 4
#      expect($options.filter(':last-child').attr('value')).toBe 'POS 3'
#      expect($options.filter(':last-child').text()).toBe 'POS 3'
#
#    it 'selects the specified POS', ->
#      expect($element.find('select[data-ng-model=device] option[selected]').attr('value')).toBe 'POS 3'
#
#  describe 'with no POS', ->
#
#    beforeEach inject ($compile, Event) ->
#      spyOn(Event, 'query').andCallFake (callback) ->
#        callback events.map (it) -> new Event(it)
#
#      $compile($element) $scope
#
#      $isolateScope = $element.isolateScope()
#      $isolateScope.reportForm =
#        $valid: true
#
#      $scope.$digest()
#
#    it 'selects all POS orders', ->
#      expect($element.find('select[data-ng-model=device] option[selected]').length).toBe 0
#
#    describe 'updating the report parameters', ->
#
#      describe 'selecting a date period', ->
#
#        describe 'in GMT', ->
#
#          beforeEach ->
#            $isolateScope.range =
#              from: moment('2014-01-01').zone(0)
#              to: moment('2014-01-01').endOf('day').zone(0)
#            $isolateScope.update()
#
#          it 'should call the update listener with the new range', ->
#            expect(listener).toHaveBeenCalled()
#            expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#            expect(listener.mostRecentCall.args[1].from).toBe '2014-01-01T00:00'
#            expect(listener.mostRecentCall.args[1].to).toBe '2014-01-01T23:59'
#
#          it 'should not send an event id parameter', ->
#            expect(listener.mostRecentCall.args[1].eventId).toBeUndefined()
#
#        describe 'in BST', ->
#
#          beforeEach ->
#            $isolateScope.range =
#              from: moment('2014-04-15').zone(1)
#              to: moment('2014-04-15').endOf('day').zone(1)
#            $isolateScope.update()
#
#          it 'should call the update listener with the new range', ->
#            expect(listener).toHaveBeenCalled()
#            expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#            expect(listener.mostRecentCall.args[1].from).toBe '2014-04-14T23:00'
#            expect(listener.mostRecentCall.args[1].to).toBe '2014-04-15T22:59'
#
#      describe 'selecting an event', ->
#
#        beforeEach ->
#          $isolateScope.event = events[0]
#          $isolateScope.update()
#
#        it 'should call the update listener with a date range based on the event', ->
#          expect(listener).toHaveBeenCalled()
#          expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#          expect(listener.mostRecentCall.args[1].eventId).toBe events[0].id
#          expect(listener.mostRecentCall.args[1].from).toBe moment(events[0].ordersAcceptedFrom).format('YYYY-MM-DDTHH:mm')
#          expect(listener.mostRecentCall.args[1].to).toBe moment(events[0].finish).format('YYYY-MM-DDTHH:mm')
#
#      describe 'selecting all POS orders', ->
#
#        beforeEach ->
#          $isolateScope.device = null
#          $isolateScope.update()
#
#        it 'should call the update listener with the POS flag', ->
#          expect(listener).toHaveBeenCalled()
#          expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#          expect(listener.mostRecentCall.args[1].origin).toBeUndefined()
#
#      describe 'selecting all POS orders', ->
#
#        beforeEach ->
#          $isolateScope.device =
#            id: 'ALL_POS'
#          $isolateScope.update()
#
#        it 'should call the update listener with the POS flag', ->
#          expect(listener).toHaveBeenCalled()
#          expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#          expect(listener.mostRecentCall.args[1].origin).toBe 'MERCHANT'
#
#      describe 'selecting all POPP orders', ->
#
#        beforeEach ->
#          $isolateScope.device =
#            id: 'ALL_POPP'
#          $isolateScope.update()
#
#        it 'should call the update listener with the POPP flag', ->
#          expect(listener).toHaveBeenCalled()
#          expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#          expect(listener.mostRecentCall.args[1].origin).toBe 'CONSUMER'
#
#      describe 'selecting a pos', ->
#
#        beforeEach ->
#          $isolateScope.device =
#            id: posList[0].uuid
#            label: posList[0].name
#          $isolateScope.update()
#
#        it 'should call the update listener with a date range based on the event', ->
#          expect(listener).toHaveBeenCalled()
#          expect(listener.mostRecentCall.args[0].name).toBe 'report:update'
#          expect(listener.mostRecentCall.args[1].pos).toBe posList[0].uuid
#          expect(listener.mostRecentCall.args[1].origin).toBe 'MERCHANT'
#
#      describe 'selecting an invalid date range', ->
#
#        beforeEach ->
#          $isolateScope.reportForm.$valid = false
#          $isolateScope.update()
#
#        it 'should not call the update listener', ->
#          expect(listener).not.toHaveBeenCalled()
