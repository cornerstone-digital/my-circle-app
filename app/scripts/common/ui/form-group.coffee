'use strict'

###
A directive that creates the container for a form input.

The directive handles assigning an error class to the container element when:

* The input is in an invalid state
* The input is dirty *or* the form has been submitted

If you provide a `label` attribute the directive will create a `<label>` element and tie its
`for` attribute to the input's `id`.

If the input does not have an `id` one is generated.
###
angular.module('smartRegisterApp')
  .service('sequence', [->
    n = 0
    next: ->
      n++
  ])
  .directive 'formGroup', ['sequence', '$timeout', (sequence, $timeout) ->
    require: '^form'
    restrict: 'C'

    link: (scope, element, attrs, formController) ->
      $form = element.closest('form')
      $input = element.find(':input')

      unless formController.submitted?
        formController.submitted = false
        $form.on 'submit', -> formController.submitted = true

        # override the $setPristine function of the form controller to also clear the submitted flag
        setPristineFn = formController.$setPristine
        formController.$setPristine = ->
          @submitted = false
          setPristineFn()
          toggleErrorState()

      toggleErrorState = ->
        $timeout ->
          element.toggleClass 'has-error', (formController.submitted or $input.hasClass('ng-dirty')) and $input.hasClass('ng-invalid')

      scope.$watch "#{$form.attr('name')}.#{$input.attr('name')}.$valid", toggleErrorState
      $input.on 'input change', toggleErrorState
      $form.on 'submit', toggleErrorState

      if attrs.label?
        unless $input.attr('id')?
          $input.attr 'id', "id_#{sequence.next().toString(16)}"

        element.prepend $ '<label></label>',
          for: $input.attr('id')
          text: attrs.label
  ]
