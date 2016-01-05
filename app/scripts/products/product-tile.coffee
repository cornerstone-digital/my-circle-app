'use strict'

angular.module('smartRegisterApp')
.directive 'productTile', [->
  restrict: 'C'
  template: '''
    <a data-ng-click="toggleMenu($event, product)" data-ng-style="productStyle()">
      <div class="image-placeholder" style="background-image: url({{productImage}})"></div>
      <h4 class="title">{{truncateTitle(product.title)}}</h4>
    </a>
    <div class="popover fade left" data-ng-class="{in: isMenuOpen(product)}">
      <div class="arrow"></div>
      <div class="popover-content">
        <button data-ng-click="edit(product)" type="button" class="btn btn-default btn-lg" data-ng-if="selectedCategory.category">Edit</button>
        <button data-ng-click="copy(product)" type="button" class="btn btn-default btn-lg" data-ng-if="selectedCategory.category">Duplicate</button>
        <button data-ng-click="confirmedDelete(product)" type="button" class="btn btn-danger btn-lg" data-ng-if="selectedCategory.category">Delete</button>
        <button data-ng-click="removeFromFavorites(product)" type="button" class="btn btn-danger btn-lg" data-ng-if="selectedCategory.favorites">Remove</button>
      </div>
    </div>
  '''
  link: ($scope, $element) ->
    $anchor = $element.find('a')
    $popover = $element.find('.popover')
    $deleteConfirm = $element.find('.delete-confirm')

    # handles a click outside the popover menu to close it
    backgroundHandler = (event) ->
      $scope.$apply $scope.closeMenus unless ($(event.originalEvent.target).is('.product-tile > a'))

    $scope.truncateTitle = (string) ->
      if string.length > 35
        return string.truncateAt(35) + "..."
      else
        return string

    $scope.$watch 'openMenu', (value) ->
      if value is $scope.product
        pos = $element.position()
        pos.top += parseInt($element.css('margin-top'), 10)
        pos.left += parseInt($element.css('margin-left'), 10)
        $popover.css
          display: 'block'
          top: pos.top + ($element.outerHeight() / 2) - ($popover.outerHeight() / 2)
          left: pos.left - $popover.outerWidth()

        $('body').on 'click', backgroundHandler
      else
        $('body').off 'click', backgroundHandler
        $popover.css
          display: 'none'

    $popover.on 'click', 'button', ->
      $scope.closeMenus()

    $scope.$on 'productsForCategory:sortstart', ->
      $scope.$apply ->
        $scope.closeMenus()

    $scope.productStyle = ->
      if angular.isDefined($scope.product)
        category = $scope.categories.filter((it) -> it.id is $scope.product.category)
        styleProps = 'background-color': category[0].colour if category.length > 0
        styleProps['color'] = "#FFFFFF"
        $scope.productImage =  $scope.product.images?[0].url ? 'styles/images/no-image.png'

#        styleProps['background-image'] = "url(#{$scope.product.images[0].url})" if $scope.product.images?.length > 0

        styleProps
]

