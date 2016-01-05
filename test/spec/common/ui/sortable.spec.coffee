'use strict'

describe 'Directive: sortable', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $element = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()

    $element = angular.element '<th sortable="foo">Foo</div>'
    $compile($element) $scope

  describe 'when the table is sorted by this column', ->
    beforeEach ->
      $scope.$apply ->
        $scope.sort = 'foo'
        $scope.reverse = false

    it 'should have an "active" class', ->
      expect($element).toHaveClass 'active'

    it 'should not have a "desc" class', ->
      expect($element).not.toHaveClass 'desc'

    describe 'clicking on the header', ->
      beforeEach ->
        $element.find('a').click()

      it 'should change sort order to descending', ->
        expect($scope.sort).toBe 'foo'
        expect($scope.reverse).toBe true

    describe 'descending', ->
      beforeEach ->
        $scope.$apply -> $scope.reverse = true

      it 'should have a "desc" class', ->
        expect($element).toHaveClass 'desc'

      describe 'clicking on the header', ->
        beforeEach ->
          $element.find('a').click()

        it 'should change sort order to ascending', ->
          expect($scope.sort).toBe 'foo'
          expect($scope.reverse).toBe false

  describe 'when the table is sorted by a different column', ->
    beforeEach ->
      $scope.$apply ->
        $scope.sort = 'bar'
        $scope.reverse = false

    it 'should not have an "active" class', ->
      expect($element).not.toHaveClass 'active'

    describe 'clicking on the header', ->
      beforeEach ->
        $element.find('a').click()

      it 'should sort by this column ascending', ->
        expect($scope.sort).toBe 'foo'
        expect($scope.reverse).toBe false

    describe 'descending', ->
      beforeEach ->
        $scope.$apply -> $scope.reverse = true

      describe 'clicking on the header', ->
        beforeEach ->
          $element.find('a').click()

        it 'should sort by this column ascending', ->
          expect($scope.sort).toBe 'foo'
          expect($scope.reverse).toBe false
