(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('productTile', [
    function() {
      return {
        restrict: 'C',
        template: '<a data-ng-click="toggleMenu($event, product)" data-ng-style="productStyle()">\n  <div class="image-placeholder" style="background-image: url({{productImage}})"></div>\n  <h4 class="title">{{truncateTitle(product.title)}}</h4>\n</a>\n<div class="popover fade left" data-ng-class="{in: isMenuOpen(product)}">\n  <div class="arrow"></div>\n  <div class="popover-content">\n    <button data-ng-click="edit(product)" type="button" class="btn btn-default btn-lg" data-ng-if="selectedCategory.category">Edit</button>\n    <button data-ng-click="copy(product)" type="button" class="btn btn-default btn-lg" data-ng-if="selectedCategory.category">Duplicate</button>\n    <button data-ng-click="confirmedDelete(product)" type="button" class="btn btn-danger btn-lg" data-ng-if="selectedCategory.category">Delete</button>\n    <button data-ng-click="removeFromFavorites(product)" type="button" class="btn btn-danger btn-lg" data-ng-if="selectedCategory.favorites">Remove</button>\n  </div>\n</div>',
        link: function($scope, $element) {
          var $anchor, $deleteConfirm, $popover, backgroundHandler;
          $anchor = $element.find('a');
          $popover = $element.find('.popover');
          $deleteConfirm = $element.find('.delete-confirm');
          backgroundHandler = function(event) {
            if (!($(event.originalEvent.target).is('.product-tile > a'))) {
              return $scope.$apply($scope.closeMenus);
            }
          };
          $scope.truncateTitle = function(string) {
            if (string.length > 35) {
              return string.truncateAt(35) + "...";
            } else {
              return string;
            }
          };
          $scope.$watch('openMenu', function(value) {
            var pos;
            if (value === $scope.product) {
              pos = $element.position();
              pos.top += parseInt($element.css('margin-top'), 10);
              pos.left += parseInt($element.css('margin-left'), 10);
              $popover.css({
                display: 'block',
                top: pos.top + ($element.outerHeight() / 2) - ($popover.outerHeight() / 2),
                left: pos.left - $popover.outerWidth()
              });
              return $('body').on('click', backgroundHandler);
            } else {
              $('body').off('click', backgroundHandler);
              return $popover.css({
                display: 'none'
              });
            }
          });
          $popover.on('click', 'button', function() {
            return $scope.closeMenus();
          });
          $scope.$on('productsForCategory:sortstart', function() {
            return $scope.$apply(function() {
              return $scope.closeMenus();
            });
          });
          return $scope.productStyle = function() {
            var category, styleProps, _ref, _ref1;
            if (angular.isDefined($scope.product)) {
              category = $scope.categories.filter(function(it) {
                return it.id === $scope.product.category;
              });
              if (category.length > 0) {
                styleProps = {
                  'background-color': category[0].colour
                };
              }
              styleProps['color'] = "#FFFFFF";
              $scope.productImage = (_ref = (_ref1 = $scope.product.images) != null ? _ref1[0].url : void 0) != null ? _ref : 'styles/images/no-image.png';
              return styleProps;
            }
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=product-tile.js.map
