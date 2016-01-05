(function() {
  'use strict';

  /*
  A directive that creates the container for a form input.
  
  The directive handles assigning an error class to the container element when:
  
  * The input is in an invalid state
  * The input is dirty *or* the form has been submitted
  
  If you provide a `label` attribute the directive will create a `<label>` element and tie its
  `for` attribute to the input's `id`.
  
  If the input does not have an `id` one is generated.
   */
  angular.module('smartRegisterApp').service('sequence', [
    function() {
      var n;
      n = 0;
      return {
        next: function() {
          return n++;
        }
      };
    }
  ]).directive('formGroup', [
    'sequence', '$timeout', function(sequence, $timeout) {
      return {
        require: '^form',
        restrict: 'C',
        link: function(scope, element, attrs, formController) {
          var $form, $input, setPristineFn, toggleErrorState;
          $form = element.closest('form');
          $input = element.find(':input');
          if (formController.submitted == null) {
            formController.submitted = false;
            $form.on('submit', function() {
              return formController.submitted = true;
            });
            setPristineFn = formController.$setPristine;
            formController.$setPristine = function() {
              this.submitted = false;
              setPristineFn();
              return toggleErrorState();
            };
          }
          toggleErrorState = function() {
            return $timeout(function() {
              return element.toggleClass('has-error', (formController.submitted || $input.hasClass('ng-dirty')) && $input.hasClass('ng-invalid'));
            });
          };
          scope.$watch("" + ($form.attr('name')) + "." + ($input.attr('name')) + ".$valid", toggleErrorState);
          $input.on('input change', toggleErrorState);
          $form.on('submit', toggleErrorState);
          if (attrs.label != null) {
            if ($input.attr('id') == null) {
              $input.attr('id', "id_" + (sequence.next().toString(16)));
            }
            return element.prepend($('<label></label>', {
              "for": $input.attr('id'),
              text: attrs.label
            }));
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=form-group.js.map
