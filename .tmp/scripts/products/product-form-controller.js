(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ProductFormCtrl', [
    '$rootScope', '$scope', '$location', '$timeout', '$route', '$filter', '$http', 'product', 'categories', 'sections', 'Auth', 'ProductService', 'MessagingService', 'ValidationService', 'ImageService', function($rootScope, $scope, $location, $timeout, $route, $filter, $http, product, categories, sections, Auth, ProductService, MessagingService, ValidationService, ImageService) {
      var $cropper, folder, getCanvas, jcrop, signature, _ref;
      $scope.product = product;
      $scope.categories = categories;
      $scope.sections = sections;
      $cropper = $('.image-cropper');
      jcrop = null;
      $scope.s3Config = null;
      folder = null;
      signature = null;
      ImageService.getS3Config().then(function(s3Config) {
        var policy;
        $scope.s3Config = s3Config;
        folder = 'products';
        policy = {
          expiration: '2020-12-01T12:00:00.000Z',
          conditions: [
            {
              bucket: s3Config.bucketName
            }, ['starts-with', '$key', ''], {
              acl: 'public-read'
            }, {
              'success_action_status': '201'
            }, ['starts-with', '$Content-Type', 'image/']
          ]
        };
        $scope.policyBase64 = $filter('base64')(policy);
        return $scope.signature = $filter('hmacSha1')($scope.policyBase64, s3Config.secretKey);
      });
      getCanvas = function() {
        return $('canvas').get(0);
      };
      $scope.getImageFile = function() {
        return $('input.imageInput').get(0).files[0];
      };
      $scope.getCroppedImage = function() {
        var array, byteString, dataURI, i, mimeString, _i, _ref;
        mimeString = $scope.getImageFile().type;
        dataURI = getCanvas().toDataURL(mimeString);
        byteString = atob(dataURI.split(',')[1]);
        array = [];
        for (i = _i = 0, _ref = byteString.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          array.push(byteString.charCodeAt(i));
        }
        return new Blob([new Uint8Array(array)], {
          type: mimeString
        });
      };
      $scope.updatePreview = function(crop) {
        var context;
        context = getCanvas().getContext('2d');
        context.clearRect(0, 0, getCanvas().width, getCanvas().height);
        context.fillStyle = '#ffffff';
        context.fill();
        return context.drawImage($('.image-cropper img').get(0), crop.x, crop.y, crop.w, crop.h, 0, 0, getCanvas().width, getCanvas().height);
      };
      $scope.imageChanged = function() {
        var reader;
        reader = new FileReader();
        reader.onload = function() {
          var $img;
          if (jcrop != null) {
            jcrop.destroy();
            $('.image-cropper img').remove();
          }
          $img = $('<img>', {
            src: reader.result
          });
          $('.image-cropper').append($img);
          return $img.Jcrop({
            aspectRatio: 1.77,
            minSize: [230, 130],
            setSelect: [0, 0, 230, 130],
            boxWidth: 400,
            boxHeight: 400,
            onChange: $scope.updatePreview,
            onSelect: $scope.updatePreview
          }, function() {
            return jcrop = this;
          });
        };
        return reader.readAsDataURL($scope.getImageFile());
      };
      $scope.validateImageSize = function(file) {
        var img;
        if (file) {
          img = new Image();
          img.src = window.URL.createObjectURL(file);
          return img.onload = function() {
            var error, height, width;
            width = img.naturalWidth;
            height = img.naturalHeight;
            window.URL.revokeObjectURL(img.src);
            if (width >= 236 && height >= 136) {
              return true;
            } else {
              error = MessagingService.createMessage('error', 'Images must be at least 236px wide by 136px high. Please choose a larger image.', 'Product');
              MessagingService.addMessage(error);
              return false;
            }
          };
        }
      };
      $scope.uploadToS3 = function(callback) {
        var file, formData, key;
        file = $scope.getImageFile();
        if (angular.isDefined(file)) {
          key = "" + folder + "/" + (Auth.getMerchant().id) + "/" + (new Date().getTime()) + "-" + file.name;
          formData = new FormData();
          formData.append('key', key);
          formData.append('acl', 'public-read');
          formData.append('success_action_status', '201');
          formData.append('Content-Type', file.type);
          formData.append('AWSAccessKeyId', $scope.s3Config.accessKeyId);
          formData.append('policy', $scope.policyBase64);
          formData.append('signature', $scope.signature);
          formData.append('file', $scope.getCroppedImage());
          return $http.post("https://" + $scope.s3Config.bucketName + ".s3.amazonaws.com/", formData, {
            headers: {
              'Content-Type': undefined
            },
            transformRequest: function(data) {
              return data;
            }
          }).success(function(data, status, headers) {
            return callback({
              filename: key,
              url: $(data).find('location').text()
            });
          });
        } else {
          return callback();
        }
      };
      $scope.deleteImage = function(image) {
        var index;
        index = $scope.product.images.indexOf(image);
        $scope.product.images.splice(index, 1);
        return $scope.save();
      };
      $scope.back = function() {
        $rootScope.backUrl = "/venues/" + $rootScope.credentials.venue.id + "/products/category/" + $scope.product.category;
        return $rootScope.back();
      };
      $scope.sectionOptions = {
        animation: false,
        placeholder: "Select a section...",
        dataTextField: "name",
        dataValueField: "id",
        maxSelectedItems: 4,
        dataSource: {
          data: $scope.sections
        },
        change: function(event) {
          return $scope.sectionIds = this.value();
        }
      };
      $scope.sectionIds = _.map(product.sections, function(productSection) {
        return productSection.id;
      });
      if (((_ref = $route.current.params) != null ? _ref.categoryId : void 0) != null) {
        $scope.product.category = Number($route.current.params.categoryId);
      } else {
        $scope.product.category = Number($scope.product.category);
      }
      if (!$scope.product.modifiers) {
        $scope.product.modifiers = [];
      }
      $timeout(function() {
        angular.element(document.querySelector(".nav-tabs")).find('a:first').tab('show');
        return angular.element(document.querySelector(".k-dropdown")).on('keydown', function(event) {
          var selectBox;
          if (event.keyCode === 9) {
            selectBox = angular.element(event.currentTarget).find('select:first');
            return $scope.moveToNextTabIndex(event, selectBox);
          }
        });
      }, 100);
      $scope.reset = function() {
        var _ref1, _ref2;
        MessagingService.resetMessages();
        ValidationService.reset();
        if ($scope.product.id != null) {
          return ProductService.getById((_ref1 = $rootScope.credentials) != null ? (_ref2 = _ref1.venue) != null ? _ref2.id : void 0 : void 0, $scope.product.id).then(function(response) {
            return $scope.product = response;
          });
        } else {
          return $scope.product = ProductService["new"]();
        }
      };
      $scope.save = function(reload) {
        var filteredSections;
        filteredSections = [];
        angular.forEach($scope.sectionIds, function(value, index) {
          var section;
          section = _.filter(sections, function(section) {
            return section.id === value;
          });
          return filteredSections.push(section);
        });
        $scope.product.sections = _.flatten(filteredSections);
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Product');
        if (!MessagingService.hasMessages('Product').length) {
          $scope.locked = true;
          if (!reload) {
            reload = false;
          }
          $scope.product.category = Number($scope.product.category);
          return $scope.uploadToS3(function(image) {
            console.log('called back');
            if (image) {
              $scope.product.images = [];
              $scope.product.images.push(image);
            }
            if ($scope.product.id != null) {
              if (sections == null) {
                $scope.product.sections = [];
              }
              return $timeout(function() {
                return ProductService.save($rootScope.credentials.venue.id, $scope.product).then(function(response) {
                  $scope.$emit('product:updated', response);
                  $scope.locked = false;
                  if (reload) {
                    return $scope.back();
                  }
                }, function(response) {
                  console.error('update failed');
                  return $scope.locked = false;
                });
              }, 100);
            } else {
              return $timeout(function() {
                return ProductService.save($rootScope.credentials.venue.id, $scope.product).then(function(response) {
                  $scope.$emit('product:created', response);
                  $scope.locked = false;
                  if (reload) {
                    return $scope.back();
                  }
                }, function(response) {
                  console.error(response);
                  return $scope.locked = false;
                });
              }, 100);
            }
          });
        }
      };

      /*
      called when a modifier is selected – this will cause the modifier section of the form
      to display the selected modifier's details
       */
      $scope.selectModifier = function(modifier) {
        return $scope.selectedModifier = modifier;
      };
      $scope.addModifier = function() {
        var newModifier;
        newModifier = {
          title: '',
          allowNone: false,
          allowMultiples: false,
          variants: []
        };
        $scope.selectedModifier = newModifier;
        return $scope.product.modifiers.push(newModifier);
      };
      $scope.deleteModifier = function() {
        var index, _ref1;
        index = $scope.product.modifiers.indexOf($scope.selectedModifier);
        if (index >= 0) {
          $scope.product.modifiers.splice(index, 1);
          return $scope.selectedModifier = (_ref1 = $scope.product.modifiers[index]) != null ? _ref1 : $scope.product.modifiers[$scope.product.modifiers.length - 1];
        }
      };
      $scope.addVariant = function() {
        var newVariant;
        newVariant = {
          title: '',
          priceDelta: 0,
          isDefault: false
        };
        if ($scope.selectedModifier.variants == null) {
          $scope.selectedModifier.variants = [];
        }
        return $scope.selectedModifier.variants.push(newVariant);
      };
      $scope.deleteVariant = function(variant) {
        var index;
        index = $scope.selectedModifier.variants.indexOf(variant);
        if (index >= 0) {
          return $scope.selectedModifier.variants.splice(index, 1);
        }
      };
      $scope.selectDefaultVariant = function(modifier, defaultVariant) {
        var variant, _i, _len, _ref1, _results;
        _ref1 = modifier.variants;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          variant = _ref1[_i];
          if (variant !== defaultVariant) {
            _results.push(variant.isDefault = false);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };
      $scope.showDataChangedMessage = function() {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("warning", "Your product data has changed. Don't forget to press the 'Save' button.", 'Venue');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Venue');
      };
      $scope.findNextElemByTabIndex = function(tabIndex) {
        var matchedElement;
        matchedElement = angular.element(document.querySelector("[tabindex='" + tabIndex + "']"));
        return matchedElement;
      };
      return $scope.moveToNextTabIndex = function($event, $element) {
        var currentElem, nextElem, _ref1, _ref2;
        currentElem = $element;
        nextElem = [];
        if ((currentElem != null ? (_ref1 = currentElem.attrs) != null ? _ref1.nexttabindex : void 0 : void 0) != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex);
        } else if (((_ref2 = currentElem[0].attributes) != null ? _ref2.nexttabindex : void 0) != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem[0].attributes.nexttabindex.value);
        }
        if (currentElem.save != null) {
          currentElem.save();
          currentElem.hide();
        }
        if (nextElem.length) {
          return $timeout(function() {
            return nextElem.click();
          }, 10);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=product-form-controller.js.map
