'use strict'

angular.module('smartRegisterApp')
  .directive('productEditForm', ['$filter', ($filter) ->
    templateUrl: 'views/partials/products/product-edit-form.html'
    replace: true
    restrict: 'E'
    controller: ['$scope', '$rootScope', '$element', '$attrs', 'ProductService', '$location', ($scope, $rootScope, $element, $attrs, ProductService, $location) ->

      $scope.$on 'product:create', (event, productToCopy) ->
        product = ProductService.new($rootScope.credentials.venue.id)

        if productToCopy?
          angular.copy productToCopy, product
          delete product.id
          product.title = ''

          nonClonedProperties = ['id', 'version', 'created']
          _.forEach product.images, (image) ->
            delete image[prop] for prop in nonClonedProperties
          _.forEach product.modifiers, (modifier) ->
            delete modifier[prop] for prop in nonClonedProperties
            _.forEach modifier.variants, (variant) ->
              delete variant[prop] for prop in nonClonedProperties

        # need to initialize these arrays so they can be assigned to
        product.price = 0 unless product.price?
        product.tax = 0 unless product.tax?
#        product.categories = [] unless product.categories?
        product.favourite = false unless product.favourite?
        product.modifiers = [] unless product.modifiers?
        product.images = [] unless product.images?

        $scope.product = product

        $scope.selectedModifier = if $scope.product.modifiers.length > 0 then $scope.product.modifiers[0] else null

        $element.find('.nav-tabs a:first').tab('show')

      $scope.$on 'product:edit', (event, product) ->
        $location.path '/products/edit/#{product.id}'
#        $scope.product = angular.copy(product)
#        $scope.product.modifiers = [] unless $scope.product.modifiers?
#        $scope.product.images = [] unless product.images?
#        $scope.selectedModifier = if $scope.product.modifiers.length > 0 then $scope.product.modifiers[0] else null
#
#        $element.find('.nav-tabs a:first').tab('show')

      $scope.cancel = ->
        delete $scope.product
        delete $scope.selectedModifier
        $scope.productForm.$setPristine()
        $scope.$broadcast 'product:closed'

      $scope.$on 'product:created', $scope.cancel
      $scope.$on 'product:updated', $scope.cancel

      $scope.save = (form) ->
        if form.$valid
          $scope.locked = true

          

#          $scope.$emit 'product:save', $scope.product
#
#          if $scope.product.id?
#            ProductService.save($rootScope.credentials.venue.id, $scope.product).then((response) ->
#              $scope.$emit 'product:updated', response
#              $scope.locked = false
#            , (response) ->
#              console.error 'update failed'
#              $scope.locked = false
#            )
#          else
#            ProductService.save($rootScope.credentials.venue.id, $scope.product).then((response) ->
#              $scope.$emit 'product:created', response
#              $scope.locked = false
#            , (response) ->
#              console.error response
#              $scope.locked = false
#            )

      ###
      called when a modifier is selected – this will cause the modifier section of the form
      to display the selected modifier's details
      ###
      $scope.selectModifier = (modifier) ->
        $scope.selectedModifier = modifier

      $scope.addModifier = ->
        newModifier =
          title: ''
          allowNone: false
          allowMultiples: false
          variants: []
        $scope.selectedModifier = newModifier
        $scope.product.modifiers.push newModifier

      $scope.deleteModifier = ->
        index = $scope.product.modifiers.indexOf $scope.selectedModifier
        if index >= 0
          $scope.product.modifiers.splice index, 1
          $scope.selectedModifier = $scope.product.modifiers[index] ? $scope.product.modifiers[$scope.product.modifiers.length - 1]

      $scope.addVariant = ->
        newVariant =
          title: ''
          priceDelta: 0
          isDefault: false
        $scope.selectedModifier.variants = [] if not $scope.selectedModifier.variants?
        $scope.selectedModifier.variants.push newVariant

      $scope.deleteVariant = (variant) ->
        index = $scope.selectedModifier.variants.indexOf variant
        if index >= 0
          $scope.selectedModifier.variants.splice index, 1

      $scope.selectDefaultVariant = (modifier, defaultVariant) ->
        for variant in modifier.variants
          variant.isDefault = false if variant isnt defaultVariant
    ]
  ])
