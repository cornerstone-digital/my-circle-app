# TODO: Write new tests for product-edit-form.spec
#'use strict'
#
#ddescribe 'Directive: productEditForm', ->
#
#  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/partials/products/product-edit-form.html'
#
#  Product = null
#  Category = null
#  categoryNames = null
#  product = null
#  $scope = null
#  $element = null
#  page = null
#
#  beforeEach inject ($compile, $rootScope, $timeout, $httpBackend, Config, _Product_, _Category_, flatWhite, croissant, categories) ->
#    $httpBackend.whenGET("#{Config.baseURL()}/api/platform/s3images").respond 200,
#      bucketName: 'a-bucket'
#      accessKeyId: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
#      secretKey: 'aVerySecretKey'
#
#    Category = _Category_
#    spyOn(Category, 'query').andCallFake ->
#      categories
#
#    Product = _Product_
#    product = new Product(flatWhite)
#
#    categoryNames = _.pluck categories, 'title'
#
#    $rootScope.categories = categories
#
#    $element = angular.element '<product-edit-form categories="categories"></product-edit-form>'
#    $element = $compile($element) $rootScope
#    $timeout.flush() # https://github.com/angular/angular.js/issues/3558#issuecomment-23439610
#    $rootScope.$digest()
#
#    page =
#      tab: (target) -> $element.find(".nav-tabs a[data-target='#{target}']")
#      productTabLink: -> @tab '#product-tab'
#      modifiersTabLink: -> @tab '#modifiers-tab'
#      productTab: -> $element.find('#product-tab')
#      productTitle: -> $element.find(':input[name=title]')
#      productCategory: -> $element.find(':input[name=category]')
#      productPrice: -> $element.find(':input[name=price]')
#      productTax: -> $element.find(':input[name=tax]')
#      productAltPrice: -> $element.find(':input[name=altPrice]')
#      productAltTax: -> $element.find(':input[name=altTax]')
#      modifiersTab: -> $element.find('#modifiers-tab')
#      modifierButtons: -> $element.find('#modifiers-tab nav a')
#      modifierForm: -> $element.find('.modifier-form')
#      modifierTitle: -> $element.find('.modifier-form :input').eq(0)
#      saveButton: -> $element.find('#product-edit-save')
#      cancelButton: -> $element.find('#product-edit-cancel')
#      addModifierButton: -> $element.find('#modifiers-tab nav .add-button')
#      deleteModifierButton: -> $element.find('#product-edit-delete-modifier')
#      addVariantButton: -> $element.find('#product-edit-add-variant')
#      variants: -> $element.find('.variant')
#
#    $scope = $element.isolateScope()
#
#    # callbacks for Bootstrap modal show/hide events so we don't have to wait for (in)visibility
#    $element.showCallback = jasmine.createSpy()
#    $element.hideCallback = jasmine.createSpy()
#    $element.on 'show.bs.modal', $element.showCallback
#    $element.on 'hide.bs.modal', $element.hideCallback
#
#    @addMatchers
#      toHaveBeenOpened: ->
#        @message = ->
#          "Expected modal dialog #{if @isNot then 'not ' else ''}to have been shown"
#        @actual.showCallback.calls.length > 0
#
#      toHaveBeenClosed: ->
#        @message = ->
#          "Expected modal dialog #{if @isNot then 'not ' else ''}to have been hidden"
#        @actual.hideCallback.calls.length > 0
#
#  describe 'displaying the form', ->
#    it 'should be hidden initially', ->
#      expect($element).not.toBeVisible()
#
#    describe 'copying an existing product', ->
#      beforeEach ->
#        $scope.$apply ->
#          $scope.$broadcast 'product:create', product
#
#      it 'should attach a copy of the product to the scope', ->
#        expect($scope.product).not.toBeUndefined()
#        expect($scope.product[field]).toBe(product[field]) for field in ['price', 'tax', 'altPrice', 'altTax', 'favourite', 'category']
#        expect(_.pluck $scope.product.modifiers, 'title').toContain modifier.title for modifier in product.modifiers
#        expect(_.pluck $scope.product.modifiers[0].variants, 'title').toContain variant.title for variant in product.modifiers[0].variants
#
#      it 'should not copy the id of the original product', ->
#        expect($scope.product.id).toBeUndefined()
#
#      it 'should not copy the id or version of any modifiers or variants', ->
#        for modifier in $scope.product.modifiers
#          expect(modifier.id).toBeUndefined()
#          expect(modifier.version).toBeUndefined()
#          for variant in modifier.variants
#            expect(variant.id).toBeUndefined()
#            expect(variant.version).toBeUndefined()
#
#      it 'should not copy the title of the original product', ->
#        expect($scope.product.title).toBe ''
#
#      it 'should select the first modifier automatically', ->
#        expect($scope.selectedModifier.title).toBe product.modifiers[0].title
#
#    describe 'creating a new product', ->
#      beforeEach ->
#        $scope.$apply ->
#          $scope.$broadcast 'product:create',
#            categories: [$scope.categories[0]]
#
#      it 'should attach an empty product to the scope', ->
#        expect($scope.product).not.toBeUndefined()
#        expect($scope.product.id).toBeUndefined()
#
#      it 'should set the category based on the one specified by the event', ->
#        expect($scope.product.categories.length).toBe 1
#        expect($scope.product.categories[0]).toEqual $scope.categories[0]
#
#      it 'should open the form', ->
#        expect($element).toHaveBeenOpened()
#
#      describe 'form sections', ->
#
#        it 'should display the product section', ->
#          expect(page.productTabLink().parent()).toHaveClass 'active'
#          expect(page.modifiersTabLink().parent()).not.toHaveClass 'active'
#
#      describe 'trying to save with invalid data', ->
#        beforeEach inject ($timeout) ->
##          spyOn $scope.product, '$save'
#
#          $scope.$apply ->
#            $element.find('form').attr('novalidate', '').get(0).reset()
#
#          page.saveButton().click()
#          $scope.$digest()
#          $timeout.flush()
#
#        iit 'should not save the product', ->
#          console.log $scope.product
##          expect($scope.product.$save).not.toHaveBeenCalled()
#
#        describe 'required fields', ->
#          for field in ['title'] # should check price and tax here as well but they don't seem to reset to blank in Phantom
#            ((name) ->
#              it "should highlight the #{name} field", ->
#                expect($element.find(":input[name=#{name}]").closest('.form-group')).toHaveClass 'has-error'
#            ) field
#
#        describe 'optional fields', ->
#          for field in ['altPrice', 'altTax']
#            ((name) ->
#              it "should not highlight the #{name} field", ->
#                expect($element.find(":input[name=#{name}]").closest('.form-group')).not.toHaveClass 'has-error'
#            ) field
#
#      describe 'filling in the form', ->
#        beforeEach ->
#          page.productTitle().val('Eggy Banjo').trigger('input')
#          page.productPrice().val('3.00').trigger('input')
#          page.productTax().val('20').trigger('input')
#          page.productCategory().find('option').last().prop 'selected', true
#          page.productCategory().trigger 'change'
#          page.addModifierButton().click()
#          page.modifierTitle().val('Bread').trigger('input')
#          for bread, i in ['white', 'brown', 'rye']
#            page.addVariantButton().click()
#            page.variants().eq(i).find(':input').eq(0).val(bread).trigger('input')
#
#        describe 'saving the new product', ->
#          createdCallback = null
#
#          beforeEach ->
#            createdCallback = jasmine.createSpy()
#            $scope.$parent.$on 'product:created', createdCallback
#
#          describe 'successfully', ->
#
#            beforeEach ->
#              spyOn($scope.product, '$save').andCallFake (successCallback, errorCallback) ->
#                successCallback @
#
#              page.saveButton().click()
#
#            it 'should close the form', ->
#              expect($element).toHaveBeenClosed()
#
#            it 'should copy the data back', ->
#              expect(createdCallback).toHaveBeenCalled()
#
#              event = createdCallback.mostRecentCall.args[0]
#              data = createdCallback.mostRecentCall.args[1]
#              expect(event.name).toBe 'product:created'
#              expect(data.id).toBeUndefined()
#              expect(data.title).toBe 'Eggy Banjo'
#
#            it 'should reset the form to pristine state', ->
#              expect($scope.productForm.$pristine).toBe true
#
#          describe 'unsuccessfully', ->
#
#            beforeEach ->
#              spyOn($scope.product, '$save').andCallFake (successCallback, errorCallback) ->
#                errorCallback
#                  status: 400
#                  data:
#                    success: false
#                    reference: '1337'
#                    message: 'I have a bad feeling about this.'
#
#              page.saveButton().click()
#
#            it 'should not close the form', ->
#              expect($element).not.toHaveBeenClosed()
#
#            it 'should not copy any data back', ->
#              expect(createdCallback).not.toHaveBeenCalled()
#
#            it 'should not reset the form state', ->
#              expect($scope.productForm.$pristine).toBe false
#
#            it 'should attach the API error message to the scope', ->
#              expect($scope.error).toBe '1337: I have a bad feeling about this.'
#
#        describe 'default values', ->
#          describe 'booleans', ->
#            it 'should default to false', ->
#              expect($scope.product.favourite).toBe false
#              expect($scope.product.modifiers[0].allowNone).toBe false
#              expect($scope.product.modifiers[0].allowMultiples).toBe false
#              expect(variant.isDefault).toBe false for variant in $scope.product.modifiers[0].variants
#
#          describe 'alternate prices', ->
#            it 'should be undefined if they are not specified', ->
#              expect($scope.product.altPrice).toBeUndefined()
#              expect($scope.product.altTax).toBeUndefined()
#
#            it 'should be undefined if removed', ->
#              page.productAltPrice().val('1.5').trigger('input')
#              page.productAltTax().val('20').trigger('input')
#              $scope.$digest()
#
#              expect($scope.product.altPrice).toBe 1.5
#              expect($scope.product.altTax).toBe 0.2
#
#              page.productAltPrice().val('').trigger('input')
#              page.productAltTax().val('').trigger('input')
#              $scope.$digest()
#
#              expect($scope.product.altPrice).toBeNull()
#              expect($scope.product.altTax).toBeNull()
#
#    describe 'when a product with no modifiers is selected for editing', ->
#      beforeEach ->
#        delete product.modifiers
#        $scope.$apply ->
#          $scope.$broadcast 'product:edit', product
#
#      it 'should default the modifiers to an empty array', ->
#        expect($scope.product.modifiers).toEqual []
#
#    describe 'when a product is selected for editing', ->
#      beforeEach ->
#        $scope.$apply ->
#          $scope.$broadcast 'product:edit', product
#
#      it 'should attach a copy of the product to the scope', ->
#        expect($scope.product.id).toBe product.id
#        expect($scope.product).not.toBe product
#
#      it 'should open the form', ->
#        expect($element).toHaveBeenOpened()
#
#      it 'should populate the form with the product data', ->
#        expect(page.productTitle().val()).toBe product.title
#
#      describe 'clicking the cancel button', ->
#
#        productCopy = null
#
#        beforeEach ->
#          productCopy = $scope.product
#          spyOn productCopy, '$update'
#          page.cancelButton().click()
#
#        it 'should close the form', ->
#          expect($element).toHaveBeenClosed()
#
#        it 'should remove the product from the scope', ->
#          expect($scope.product).toBeFalsy()
#
#        it 'should not try to update the product', ->
#          expect(productCopy.$update).not.toHaveBeenCalled()
#
#      describe 'editing product data', ->
#
#        originalTitle = null
#
#        beforeEach ->
#          originalTitle = $scope.product.title
#          page.productTitle().val('AN EDITED TITLE').trigger 'input'
#
#        it 'should be reflected in the scope', ->
#          expect($scope.product.title).toBe 'AN EDITED TITLE'
#
#        describe 'clicking the cancel button', ->
#          beforeEach ->
#            $scope.cancel()
#
#          it 'should have reset the product data', ->
#            expect(product.title).toBe originalTitle
#
#          it 'should reset the form to pristine state', ->
#            expect($scope.productForm.$pristine).toBe true
#
#        describe 'clicking the save button', ->
#
#          productCopy = null
#          updatedCallback = null
#
#          beforeEach ->
#            productCopy = $scope.product
#            updatedCallback = jasmine.createSpy()
#            $scope.$parent.$on 'product:updated', updatedCallback
#
#          describe 'sending the update request', ->
#            beforeEach ->
#              spyOn(productCopy, '$update')
#              page.saveButton().click()
#
#            it 'should update the product', ->
#              expect(productCopy.$update).toHaveBeenCalled()
#
#            it 'should disable the form buttons', ->
#              expect(page.saveButton()).toBeDisabled()
#              expect(page.cancelButton()).toBeDisabled()
#
#          describe 'if the update succeeds', ->
#            beforeEach ->
#              spyOn(productCopy, '$update').andCallFake (successCallback, errorCallback) ->
#                successCallback @
#
#              page.saveButton().click()
#
#            it 'should close the form', ->
#              expect($element).toHaveBeenClosed()
#
#            it 'should copy the data back', ->
#              expect(updatedCallback).toHaveBeenCalled()
#              expect(updatedCallback.mostRecentCall.args[0].name).toBe 'product:updated'
#              expect(updatedCallback.mostRecentCall.args[1].id).toBe product.id
#              expect(updatedCallback.mostRecentCall.args[1].title).toBe 'AN EDITED TITLE'
#
#          describe 'if the update fails', ->
#            beforeEach ->
#              spyOn(productCopy, '$update').andCallFake (successCallback, errorCallback) ->
#                errorCallback
#                  status: 400
#                  data:
#                    success: false
#                    reference: '1337'
#                    message: 'I have a bad feeling about this.'
#
#              page.saveButton().click()
#
#            it 'should keep the form open', ->
#              expect($element).not.toHaveBeenClosed()
#
#            it 'should re-enable the form buttons', ->
#              expect(page.cancelButton()).not.toBeDisabled()
#
#            it 'should not signal a successful update', ->
#              expect(updatedCallback).not.toHaveBeenCalled()
#
#            it 'should attach the API error message to the scope', ->
#              expect($scope.error).toBe '1337: I have a bad feeling about this.'
#
#      describe 'product categories', ->
#        it 'should display a select option for each category', ->
#          expect(page.productCategory().find('option').length).toBe categoryNames.length
#
#        it 'should order the options alphabetically', ->
#          options = page.productCategory().find('option')
#          expect(options.eq(i).text()).toBe(category) for category, i in categoryNames.sort()
#
#        it 'should check the category for the product', ->
#          selectedCategories = page.productCategory().find(':selected')
#          expect(selectedCategories.length).toBe 1
#          expect(selectedCategories.text()).toBe 'coffee'
#
#        describe 'selecting a different category', ->
#          beforeEach ->
#            page.productCategory().find('option').last().prop 'selected', true
#            page.productCategory().trigger 'change'
#
#          it 'should update the product category', ->
#            expect($scope.product.category).toBe 7
#
#      describe 'product modifiers', ->
#
#        sortedModifiers = null
#
#        beforeEach ->
#          sortedModifiers = _.sortBy product.modifiers, 'title'
#
#        it 'should display a button for each modifier', ->
#          expect(page.modifierButtons().length).toBe product.modifiers.length
#          expect(page.modifierButtons().eq(i).text().trim()).toBe(modifier.title) for modifier, i in sortedModifiers
#
#        it 'should select the first modifier section of the form', ->
#          expect(page.modifierForm()).not.toBeHidden()
#          expect($scope.selectedModifier.title).toBe product.modifiers[0].title
#
#        describe 'selecting a modifer', ->
#
#          beforeEach ->
#            page.modifierButtons().eq(1).click()
#
#          it 'should display the modifier form', ->
#            expect(page.modifierForm()).not.toBeHidden()
#
#          it 'should populate the modifer form with the modifier data', ->
#            expect(page.modifierForm().find(':input').eq(0).val()).toBe sortedModifiers[1].title
#            expect(page.modifierForm().find('.variant').length).toBe sortedModifiers[1].variants.length
#
#          it 'should enable the delete modifier button', ->
#            expect(page.deleteModifierButton()).not.toBeDisabled()
#
#          it 'should enable the add variant button', ->
#            expect(page.addVariantButton()).not.toBeDisabled()
#
#          describe 'selecting a different modifier', ->
#            beforeEach ->
#              page.modifierButtons().eq(0).click()
#
#            it 'should populate the modifer form with the modifier data', ->
#              expect(page.modifierTitle().val()).toBe sortedModifiers[0].title
#              expect(page.modifierForm().find('.variant').length).toBe sortedModifiers[0].variants.length
#
#          describe 'adding a new variant', ->
#            beforeEach ->
#              $scope.$apply -> $scope.addVariant()
#
#            it 'should add a new variant to the current modifier', ->
#              expect($scope.selectedModifier.variants.length).toBe sortedModifiers[1].variants.length + 1
#
#            it 'should default the price delta to zero', ->
#              expect($scope.selectedModifier.variants[$scope.selectedModifier.variants.length - 1].priceDelta).toBe 0
#
#            it 'should require a variant title', ->
#              expect(page.variants().last().find(':input[name="variant.title"]')).toHaveClass 'ng-invalid-required'
#
#          describe 'deleting a variant', ->
#            beforeEach ->
#              page.variants().eq(1).find('.delete-button').click()
#
#            it 'should remove the specific variant from the modifier', ->
#              expect($scope.selectedModifier.variants.length).toBe sortedModifiers[1].variants.length - 1
#
#              remainingVariants = _.pluck $scope.selectedModifier.variants, 'title'
#              expect(remainingVariants).not.toContain sortedModifiers[1].variants[1].title
#              expect(remainingVariants).toContain variantName for variantName in [sortedModifiers[1].variants[0].title, sortedModifiers[1].variants[2].title]
#
#          describe 'deleting the modifier', ->
#            beforeEach ->
#              page.deleteModifierButton().click()
#
#            it 'should remove the currently selected modifier from the product', ->
#              expect($scope.product.modifiers.length).toBe product.modifiers.length - 1
#
#            it 'should display the previous modifier in the list', ->
#              expect(page.modifierForm().find(':input').eq(0).val()).toBe sortedModifiers[0].title
#              expect(page.modifierForm().find('.variant').length).toBe sortedModifiers[0].variants.length
#
#          describe 'changing the default variant', ->
#            beforeEach ->
#              $scope.selectDefaultVariant $scope.selectedModifier, $scope.selectedModifier.variants[0]
#
#            it 'should de-select the existing default', ->
#              expect(variant.isDefault).toBe false for variant in $scope.selectedModifier.variants[1..2]
#
#        describe 'adding a new modifier', ->
#          beforeEach ->
#            page.addModifierButton().click()
#
#          it 'should add a new modifier to the product', ->
#            expect($scope.product.modifiers.length).toBe product.modifiers.length + 1
#
#          it 'should display the modifier form', ->
#            expect(page.modifierForm()).not.toBeHidden()
#
#          it 'should require a modifier title', ->
#            expect(page.modifierTitle()).toHaveClass 'ng-invalid-required'
#
#        describe 'when no modifier is selected', ->
#          beforeEach ->
#            $scope.selectedModifier = null # this is a bit artificial as there's no way to do this via the UI
#            $scope.$digest()
#
#          it 'clicking the delete modifier button should do nothing', ->
#            page.deleteModifierButton().click()
#            expect($scope.product.modifiers.length).toBe product.modifiers.length
#
#          it 'should disable the delete modifier button', ->
#            expect(page.deleteModifierButton()).toBeDisabled()
#
#          it 'should disable the add variant button', ->
#            expect(page.addVariantButton()).toBeDisabled()
