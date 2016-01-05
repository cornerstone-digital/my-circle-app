'use strict'

describe 'Directive: dateRange', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $element = null
  $isolateScope = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()
    $scope.model =
      from: null
      to: null
    $element = angular.element '<form name="myForm"><div date-range="model" data-disabled="enabled == \'no\'"/></form>'
    $compile($element) $scope

    $isolateScope = $element.find('div').isolateScope()

  describe 'rendering', ->

    allText = -> $(@).text()

    it 'should attach a select for the range type', ->
      expect($element.find('option').map(allText).get()).toEqual ['Today', 'Yesterday', 'This week', 'Last week', 'This month', 'Last month', 'This year', 'Custom date']

    it 'should create datetime-local inputs for the from and to dates', ->
      expect($element.find(':input[type=datetime-local]').length).toBe 2

  describe 'selecting range types', ->

    $range = null
    $fromDate = null
    $toDate = null
    selectRange = (text) ->
      $range.val $range.find("option:contains('#{text}')").attr('value')
      $range.trigger 'change'

    beforeEach ->
      $range = $element.find('select')
      $fromDate = $element.find(':input[type=datetime-local]').eq(0)
      $toDate = $element.find(':input[type=datetime-local]').eq(1)

    describe 'today', ->

      beforeEach ->
        selectRange 'Today'

      it 'should set the from date to today', ->
        expect($fromDate.val()).toBe moment().format('YYYY-MM-DDT00:00')

      it 'should set the to date to blank', ->
        expect($toDate.val()).toBe 'Invalid date'
        expect($isolateScope.dateRange.to).toBeNull()

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'yesterday', ->

      beforeEach ->
        selectRange 'Yesterday'

      it 'should set the from date to yesterday', ->
        expect($fromDate.val()).toBe moment().subtract('days', 1).format('YYYY-MM-DDT00:00')

      it 'should set the to date to the start of today', ->
        expect($toDate.val()).toBe moment().format('YYYY-MM-DDT00:00')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'this week', ->

      beforeEach ->
        selectRange 'This week'

      it 'should set the from date to the start of the week', ->
        expect($fromDate.val()).toBe moment().startOf('week').format('YYYY-MM-DDTHH:mm')

      it 'should set the from date to the start of the week', ->
        expect($toDate.val()).toBe moment().endOf('week').format('YYYY-MM-DDTHH:mm')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'last week', ->

      beforeEach ->
        selectRange 'Last week'

      it 'should set the from date to the start of the week', ->
        expect($fromDate.val()).toBe moment().subtract('weeks', 1).startOf('week').format('YYYY-MM-DDTHH:mm')

      it 'should set the from date to the start of the week', ->
        expect($toDate.val()).toBe moment().subtract('weeks', 1).endOf('week').format('YYYY-MM-DDTHH:mm')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'this month', ->

      beforeEach ->
        selectRange 'This month'

      it 'should set the from date to the start of the month', ->
        expect($fromDate.val()).toBe moment().startOf('month').format('YYYY-MM-DDTHH:mm')

      it 'should set the from date to the start of the month', ->
        expect($toDate.val()).toBe moment().endOf('month').format('YYYY-MM-DDTHH:mm')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'last month', ->

      beforeEach ->
        selectRange 'Last month'

      it 'should set the from date to the start of the month', ->
        expect($fromDate.val()).toBe moment().subtract('months', 1).startOf('month').format('YYYY-MM-DDTHH:mm')

      it 'should set the from date to the start of the month', ->
        expect($toDate.val()).toBe moment().subtract('months', 1).endOf('month').format('YYYY-MM-DDTHH:mm')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'this year', ->

      beforeEach ->
        selectRange 'This year'

      it 'should set the from date to the start of the year', ->
        expect($fromDate.val()).toBe moment().startOf('year').format('YYYY-MM-DDTHH:mm')

      it 'should set the from date to the start of the year', ->
        expect($toDate.val()).toBe moment().endOf('year').format('YYYY-MM-DDTHH:mm')

      it 'should make the both dates read only', ->
        expect($fromDate.prop('readonly')).toBe true
        expect($toDate.prop('readonly')).toBe true

    describe 'custom', ->

      beforeEach ->
        selectRange 'Custom date'

      it 'should make the both dates read write', ->
        expect($fromDate.prop('readonly')).toBe false
        expect($toDate.prop('readonly')).toBe false

      describe 'validation', ->

        beforeEach ->
          $fromDate.val('2014-02-02T00:00').trigger('change')
          $toDate.val('2014-02-03T00:00').trigger('change')

        it 'accepts a valid date range', ->
          expect($fromDate).not.toHaveClass 'ng-invalid'
          expect($toDate).not.toHaveClass 'ng-invalid'

        describe 'attempting to enter a to date before the from date', ->

          beforeEach ->
            $toDate.val('2014-02-01T00:00').trigger('change')

          it 'marks the to date as invalid', ->
            expect($toDate).toHaveClass 'ng-invalid'

        describe 'attempting to enter a from date after the to date', ->

          beforeEach ->
            $fromDate.val('2014-02-04T00:00').trigger('change')

          it 'marks the to date as invalid', ->
            expect($toDate).toHaveClass 'ng-invalid'

    describe 'disabling and enabling', ->

      describe 'the disabled expression is false', ->

        beforeEach ->
          $scope.$apply ->
            $scope.enabled = 'yes'

        it 'should enable all the controls', ->
          expect($element.find('select')).not.toBeDisabled()

      describe 'the disabled expression is true', ->

        beforeEach ->
          $scope.$apply ->
            $scope.enabled = 'no'

        it 'should enable all the controls', ->
          expect($element.find('select')).toBeDisabled()
