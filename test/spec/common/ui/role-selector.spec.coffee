'use strict'

describe 'Directive: roleSelector', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $element = null
  $checkboxes = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()

    $element = angular.element '<div role-selector="roleList"></div>'
    $element = $compile($element) $scope

    $checkboxes = $element.find(':checkbox')

  describe 'rendering', ->

    it 'should render a checkbox for each role', ->
      expect($checkboxes.length).toBe 2
      expect($checkboxes.eq(idx).parent().text().trim()).toBe label for label, idx in ['Staff', 'Merchant admin']

  describe 'checked state', ->

    describe 'when the list does not exist', ->

      it 'un-checks all checkboxes', ->
        expect($checkboxes.eq(idx)).not.toMatchSelector ':checked' for idx in [0...$checkboxes.length]

    describe 'when the list is empty', ->

      beforeEach ->
        $scope.roleList = []
        $scope.$digest()

      it 'un-checks all checkboxes', ->
        expect($checkboxes.eq(idx)).not.toMatchSelector ':checked' for idx in [0...$checkboxes.length]

    describe 'when the list is not empty', ->

      beforeEach ->
        $scope.roleList = [
          name: 'MERCHANT_ADMINISTRATORS'
        ]
        $scope.$digest()

      it 'checks any checkboxes whose value is in the list', ->
        expect($checkboxes.eq(1)).toMatchSelector ':checked'

      it 'un-checks any checkboxes whose value is not in the list', ->
        expect($checkboxes.eq(0)).not.toMatchSelector ':checked'

  describe 'un-checking a checkbox', ->

    beforeEach ->
      $scope.roleList = [
        name: 'MERCHANT_EMPLOYEE'
      ,
        name: 'MERCHANT_ADMINISTRATORS'
      ,
        name: 'PLATFORM_ADMINISTRATORS'
      ]
      $scope.$digest()

      $checkboxes.eq(1).click().trigger('change')

    it 'removes the checkbox value from the list', ->
      expect($scope.roleList.length).toBe 2
      expect(_.pluck $scope.roleList, 'name').toBeEqualSet ['MERCHANT_EMPLOYEE', 'PLATFORM_ADMINISTRATORS']

    it 'un-checks the checkbox', ->
      expect($checkboxes.eq(1)).not.toMatchSelector ':checked'

  describe 'checking a checkbox', ->

    beforeEach ->
      $scope.roleList = [
        name: 'PLATFORM_ADMINISTRATORS'
      ]
      $scope.$digest()

      $checkboxes.eq(1).click().trigger('change')

    it 'adds the group value to the list', ->
      expect(_.pluck $scope.roleList, 'name').toBeEqualSet ['MERCHANT_ADMINISTRATORS', 'PLATFORM_ADMINISTRATORS']

    it 'checks the checkbox', ->
      expect($checkboxes.eq(1)).toMatchSelector ':checked'
