angular.module('smartRegisterApp')
.directive('validateData', ['$timeout', ($timeout) ->
    restrict: "A"
    scope:
      data: '=validateData'
      rules: '=rules'
      match: '=matchData'

    controller: ['$scope','MessagingService','ValidationService', ($scope, MessagingService, ValidationService) ->
      $scope.hasRule = (rules, ruleName) ->
        matched = false

        angular.forEach rules, (value,index) ->
          if value == ruleName
            matched = true

        return matched

      $scope.validate = ($scope, $element, $attrs) ->
        label = $element.find('label:first')
        $scope.error  = null


        if($scope.hasRule($scope.rules, 'required'))

          type = null unless $attrs.type

          if(!ValidationService.isRequired($scope.data, type))
            errorFound = true

          if errorFound
            $scope.error = MessagingService.createMessage('error', $attrs.displayname + ' is required.', $attrs.groupname)
            MessagingService.addMessage($scope.error)

        if($scope.hasRule($scope.rules, 'numeric'))
          if(!ValidationService.isNumeric($scope.data))
            $scope.error = MessagingService.createMessage('error', $attrs.displayname + ' must be numeric', $attrs.groupname)
            MessagingService.addMessage($scope.error)

        if($scope.hasRule($scope.rules, 'match'))
          matchElement = angular.element( document.querySelector("input[name=#{$attrs.matchData}]") )
          value1 = $scope.data
          value2 = matchElement[0].value

          if(!ValidationService.isMatch(value1, value2))
            $scope.error = MessagingService.createMessage('error', "The values of ''" + matchElement.parent().context.placeholder + "' and '" + $attrs.displayname  + "' must match.", $attrs.groupname)
            MessagingService.addMessage($scope.error)

        if($scope.hasRule($scope.rules, 'email'))
          if(!ValidationService.isEmail($scope.data))
            $scope.error = MessagingService.createMessage('error', $attrs.displayname  + " must be a valid email address.", $attrs.groupname)
            MessagingService.addMessage($scope.error)

        if $scope.error?
          label.addClass('hasError')
          delete $scope.error
    ]

    link: ($scope, $element, $attrs) ->

      $scope.$on 'validate-data:validate', ($event, group) ->

        if $attrs.groupname is group
          $scope.validate($scope, $element, $attrs)

      $scope.$on 'validate-data:reset', ->
        label = $element.find('label:first')
        label.removeClass('hasError')

])
