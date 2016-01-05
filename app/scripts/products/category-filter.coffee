'use strict'

angular.module('smartRegisterApp')

.filter('category', [ ->
  (products, predicate) ->
    if predicate?
      products.filter (product) ->
        if predicate.favorites then product.favourite else product.category is predicate?.category?.id
    else []
])

.directive('categoryFilter', [->
  restrict: 'E'
  scope:
    categories: '='
    selected: '='
    sections: '='
  templateUrl: 'views/partials/products/category-filter.html'
  controller: ['$scope', '$rootScope', '$element', '$timeout', '$location', 'Colors', 'VenueService', 'CategoryService', 'ModalService', 'ProductService', ($scope, $rootScope, $element, $timeout, $location, Colors, VenueService, CategoryService, ModalService, ProductService) ->

    $scope.categoryModal = angular.element $('#categoryModal')
    $scope.sectionDropdown = angular.element $('#sectionNames')

    $scope.renderModal = ->
      options = {
        scope: $scope
        width: "600px",
        title: "Edit Category",
        actions: [
          "Pin",
          "Minimize",
          "Maximize",
          "Close"
        ]
        apiEvents:
          close: $scope.cancel
        templateUrl: 'views/partials/products/categoryModal.html'
      }

      ModalService.createWindow('categoryModal', options)

      VenueService.getVenueSections($rootScope.credentials.venue.id).then((response)->
        $scope.sections = response
      )

      $timeout ->
          if (!$('#sectionNames').data("kendoMultiSelect"))
            $scope.sectionIds = _.map($scope.selected.category.sections, (categorySection) ->
              categorySection.id
            )
            $('#sectionNames').kendoMultiSelect({
              animation: false
              open: ->
              placeholder: "Select a section..."
              dataTextField: "name"
              dataValueField: "id"
              maxSelectedItems: 4
              dataSource: {
                data: $scope.sections
              }
              value: $scope.sectionIds
              change: (event) ->
                $scope.sectionIds = this.value()
            })

      , 100

    $scope.palette = [
      '#b0cffe'
      '#2ca8c2'
      '#5481e5'
      '#913ccc'
      '#b179a3'
      '#df93ff'
      '#c93237'
      '#f05f74'
      '#f76d3c'
      '#fcb96b'
      '#e0be2f'
      '#948d61'
      '#168349'
      '#839097'
      '#bfbfbf'
      '#e5a760'
    ]

    $scope.hasCategories = ->
      if(angular.isArray($scope.categories) && $scope.categories.length)
        return true
      else
        return false

    $scope.canDeleteCategory = ->
      !$scope.$parent.products.length

#    $scope.forceDeleteCategory = (category) ->
#      angular.forEach $scope.$parent.products, (product, index) ->
#        ProductService.remove(product).then((response)->
#          $scope.$parent.products = _.reject $scope.$parent.products, (it) -> it.id is product.id
#
#          if canDeleteCategory()
#            $scope.deleteCategory()
#        )



    $scope.deleteCategory = ->
      category = $scope.selected.category

      if $scope.canDeleteCategory()
        category = $scope.selected.category
        CategoryService.remove(category).then((response)->
          $scope.categories = _.reject $scope.categories, (it) -> it.id is category.id
          $scope.$parent.selectedCategory.category = $scope.categories[0]
        )
#      else
#        if confirm("Deleting this category will also delete any associated products.")
#          $scope.forceDeleteCategory(category)

    $scope.selectCategory = (category) ->
      $scope.$parent.selectCategory category

    $scope.selectFavorites = ->
      $scope.selected =
        category: null
        favorites: true

    $scope.isSelected = (category) ->
      $scope.selected.category?.id is category.id

    $scope.isFavoritesSelected = ->
     $scope.selected?.favorites ? false

    $scope.create = ->
      $scope.category = {
        colour: $scope.palette[0]
      }
      $timeout ->
        $scope.renderModal()
      , 200

    $scope.edit = (category) ->
      $scope.category = angular.copy category

      $scope.sectionIds = _.map($scope.category.sections, (categorySection) ->
        categorySection.id
      )
      $timeout ->
        $scope.renderModal()
      , 200

    $scope.save = (category) ->
        $scope.locked = true

        filteredSections = []
        angular.forEach $scope.sectionIds, (value, index) ->
          section = _.filter($scope.sections, (section) ->
            section.id == value
          )

          filteredSections.push section

        $scope.category.sections = _.flatten(filteredSections)

        if category.id?
          CategoryService.save($rootScope.credentials.venue.id, category).then((response) ->
            for index in [0...$scope.categories.length]
              $scope.categories[index] = category if $scope.categories[index].id is category.id

            $scope.selected.category = category if $scope.selected.category?.id is category.id

            $scope.$emit 'category:updated', response
            $scope.selectCategory(category)
            delete $scope.category
            delete $scope.locked
            $('#categoryModal').data("kendoWindow").close()
          , (response) ->
            console.error "failed to update category '#{category.title}'"
            delete $scope.locked
          )
        else
          # Make sure the new index is always at the bottom
          category.index = $scope.categories.length + 1

          CategoryService.save($rootScope.credentials.venue.id, category).then((response) ->
            $scope.$emit 'category:created', response
            $scope.categories.push response
            $scope.selectCategory(response)

            delete $scope.category
            delete $scope.locked
            $('#categoryModal').data("kendoWindow").close()
          , (response) ->
            console.error "failed to save category '#{category.title}'"
            delete $scope.locked
          )

    $scope.cancel = ->
      delete $scope.category
  ]
])

.directive('productGrid', ['$timeout', ($timeout) ->
  restrict: 'C'
  link: ($scope, $element) ->
    $scope.$watch 'selectedCategory', (value) ->
      height = $('.category-filter').height() - $element.prev().outerHeight() - parseInt($element.prev().css('margin-bottom'), 10)
      $element.css
        'min-height': "#{height}px"
])
