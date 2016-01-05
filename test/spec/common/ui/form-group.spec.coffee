'use strict'

describe 'Directive: formGroup', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $timeout = null

  beforeEach inject ($rootScope, _$timeout_) ->
    $scope = $rootScope.$new()
    $timeout = _$timeout_

  describe 'rendering', ->

    $element = null
    $input = null
    $label = null

    describe 'with a label attribute', ->

      beforeEach inject ($compile) ->
        $scope.foo = ''

        template = '''
          <form name="myForm" onsubmit="return false">
            <div class="form-group" label="Foo">
              <input type="text" id="foo" ng-model="foo">
            </div>
          </form>
        '''
        $form = $compile(template) $scope

        $element = $form.children().eq(0)
        $label = $element.find('label')
        $input = $element.find(':input')

      it 'should replace the directive element with a form-group', ->
        expect($element).toBeA 'div'
        expect($element).toHaveClass 'form-group'

      it 'should transclude the directive element contents', ->
        expect($input).toBeA 'input'
        expect($input.attr('ng-model')).toBe 'foo'

      it 'should create a label tied to the input', ->
        expect($label).toBeA 'label'
        expect($label.text()).toBe 'Foo'
        expect($label.attr('for')).toBe 'foo'

    describe 'without a label attribute', ->

      beforeEach inject ($compile) ->
        $scope.foo = ''

        template = '''
          <form name="myForm" onsubmit="return false">
            <div class="form-group">
              <input type="text" ng-model="foo">
            </div>
          </form>
        '''
        $form = $compile(template) $scope

        $element = $form.children().eq(0)
        $label = $element.find('label')
        $input = $element.find(':input')

      it 'should not create a label', ->
        expect($label.length).toBe 0
        expect($element.children().eq(0)).toBeA 'input'

      it 'should not create an id for the input', ->
        expect($input.attr('id')).toBeUndefined()

    describe 'with no id on the input', ->

      $input2 = null

      beforeEach inject ($compile) ->
        $scope.foo = ''
        $scope.bar = ''

        template = '''
          <form name="myForm" onsubmit="return false">
            <div class="form-group" label="Foo">
              <input type="text" ng-model="foo">
            </div>
            <div class="form-group" label="Bar">
              <input type="text" ng-model="bar">
            </div>
          </form>
        '''
        $form = $compile(template) $scope

        $element = $form.children().eq(0)
        $label = $element.find('label')
        $input = $element.find(':input')
        $input2 = $form.find(':input').eq(1)

      it 'should create an id', ->
        expect(input.attr('id')).toMatch(/id_[\da-z]+/) for input in [$input, $input2]

      it 'should tie the id to the label', ->
        expect($label.attr('for')).toBe $input.attr('id')

      it 'should make the id unique', ->
        expect($input.attr('id')).not.toBe $input2.attr('id')

  describe 'validation', ->

    formController = null
    $form = null
    $element1 = null
    $element2 = null
    $input1 = null
    $input2 = null

    beforeEach inject ($compile) ->
      $scope.foo = ''
      $scope.bar = ''

      template = '''
        <form name="myForm" onsubmit="return false">
          <div class="form-group" label="Foo">
            <input type="text" id="foo" ng-model="foo" required>
          </div>
          <div class="form-group" label="Bar">
            <input type="text" id="bar" ng-model="bar" required>
          </div>
        </form>
      '''
      $form = $compile(template) $scope

      $element1 = $form.children().eq(0)
      $input1 = $element1.find(':input')
      $element2 = $form.children().eq(1)
      $input2 = $element2.find(':input')

      formController = $scope[$form.attr('name')]

    describe 'an empty string', ->

      describe 'in a pristine input', ->

        beforeEach ->
          $scope.$digest()
          $timeout.flush()

        it 'is not dirty', ->
          expect($input1).not.toHaveClass 'ng-dirty'

        it 'is not valid', ->
          expect($input1).toHaveClass 'ng-invalid'

        it 'should not have an error class', ->
          expect($element1).not.toHaveClass 'has-error'

      describe 'in a dirty input', ->

        beforeEach ->
          # set a value in the input and reset its state to pristine
          $input1.val('foo').trigger 'input'
          $input2.val('bar').trigger 'input'
          formController.$setPristine()

          # simulate clearing the input
          $input1.val('').trigger('input')
          $timeout.flush()

        it 'is dirty', ->
          expect($input1).toHaveClass 'ng-dirty'

        it 'is not valid', ->
          expect($input1).toHaveClass 'ng-invalid'

        it 'should have an error class', ->
          expect($element1).toHaveClass 'has-error'

        it 'does not affect the dirty state of another field', ->
          expect($input2).not.toHaveClass 'ng-dirty'

        it 'does not affect the validity of another field', ->
          expect($input2).not.toHaveClass 'ng-invalid'

        it 'does not add an error class to another field', ->
          expect($element2).not.toHaveClass 'has-error'

      describe 'in a form that has been submitted', ->

        beforeEach inject ($timeout) ->
          $scope.$apply -> $form.submit()
          $timeout.flush()

        it 'knows the form has been submitted', ->
          expect(formController.submitted).toBe true

        it 'is not dirty', ->
          expect($input1).not.toHaveClass 'ng-dirty'

        it 'is not valid', ->
          expect($input1).toHaveClass 'ng-invalid'

        it 'should have an error class', ->
          expect($element1).toHaveClass 'has-error'

        describe 'and then reset to pristine', ->

          beforeEach ->
            $scope.$apply -> formController.$setPristine()
            $timeout.flush()

          it 'should not have an error class', ->
            expect($element1).not.toHaveClass 'has-error'
