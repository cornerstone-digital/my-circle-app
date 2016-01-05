(function() {
  'use strict';
  angular.module('smartRegisterApp').constant('productImageSize', [
    function() {
      return Object.freeze({
        width: 230,
        height: 130
      });
    }
  ]).directive('s3ImageUploader', [
    '$http', '$filter', '$timeout', 'Config', 'Auth', 'ImageService', 'MessagingService', function($http, $filter, $timeout, Config, Auth, ImageService, MessagingService) {
      return {
        replace: true,
        restrict: 'E',
        scope: true,
        templateUrl: 'views/partials/images/s3-image-uploader.html',
        link: function($scope, $element) {
          var $cancelButton, $cropButton, $cropper, $deleteButton, $input, $preview, canvas, folder, jcrop, signature;
          $input = $element.find(':input');
          $cropButton = $element.find('button.crop');
          $cancelButton = $element.find('button.cancel');
          $deleteButton = $element.find('button.delete');
          $preview = $element.find('.image-preview');
          canvas = $preview.find('canvas').get(0);
          $cropper = $element.find('.image-cropper');
          jcrop = null;
          folder = null;
          signature = null;
          return ImageService.getS3Config().then(function(s3Config) {
            var deleteFromS3, finishCrop, getCroppedImage, getFile, policy, policyBase64, updatePreview, uploadToS3, validateImageSize;
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
            policyBase64 = $filter('base64')(policy);
            signature = $filter('hmacSha1')(policyBase64, s3Config.secretKey);
            getFile = function() {
              return $input.get(0).files[0];
            };
            getCroppedImage = function() {
              var array, byteString, dataURI, i, mimeString, _i, _ref;
              mimeString = getFile().type;
              dataURI = canvas.toDataURL(mimeString);
              byteString = atob(dataURI.split(',')[1]);
              array = [];
              for (i = _i = 0, _ref = byteString.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
                array.push(byteString.charCodeAt(i));
              }
              return new Blob([new Uint8Array(array)], {
                type: mimeString
              });
            };
            updatePreview = function(crop) {
              var context;
              context = canvas.getContext('2d');
              context.clearRect(0, 0, canvas.width, canvas.height);
              context.fillStyle = '#ffffff';
              context.fill();
              return context.drawImage($cropper.find('img').get(0), crop.x, crop.y, crop.w, crop.h, 0, 0, canvas.width, canvas.height);
            };
            validateImageSize = function(file) {
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
            $input.on('change', function() {
              var isValid;
              isValid = validateImageSize(getFile());
              return $timeout(function() {
                var reader;
                if (isValid && !MessagingService.hasMessages('Product').length) {
                  reader = new FileReader();
                  reader.onload = function() {
                    var $img;
                    if (jcrop != null) {
                      jcrop.destroy();
                      $cropper.find('img').remove();
                    }
                    $img = $('<img>', {
                      src: reader.result
                    });
                    $cropper.append($img);
                    return $img.Jcrop({
                      aspectRatio: 1.77,
                      minSize: [230, 130],
                      setSelect: [0, 0, 230, 130],
                      boxWidth: 400,
                      boxHeight: 400,
                      onChange: updatePreview,
                      onSelect: updatePreview
                    }, function() {
                      return jcrop = this;
                    });
                  };
                  return reader.readAsDataURL(getFile());
                }
              }, 200);
            });
            uploadToS3 = function(callback) {
              var file, formData, key;
              file = getFile();
              if (file != null) {
                key = "" + folder + "/" + (Auth.getMerchant().id) + "/" + (new Date().getTime()) + "-" + file.name;
                formData = new FormData();
                formData.append('key', key);
                formData.append('acl', 'public-read');
                formData.append('success_action_status', '201');
                formData.append('Content-Type', file.type);
                formData.append('AWSAccessKeyId', s3Config.accessKeyId);
                formData.append('policy', policyBase64);
                formData.append('signature', signature);
                formData.append('file', getCroppedImage());
                return $http.post("https://" + s3Config.bucketName + ".s3.amazonaws.com/", formData, {
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
              }
            };
            deleteFromS3 = function(image) {
              var bucket, params;
              bucket = new AWS.S3({
                params: {
                  Bucket: s3Config.bucketName
                }
              });
              params = {
                Bucket: s3Config.bucketName,
                Key: image.url
              };
              return bucket.deleteObject(params, function(err, data) {
                if (err != null) {
                  return console.log(err);
                } else {
                  return console.log(data);
                }
              });
            };
            finishCrop = function() {
              $input.val('');
              if (jcrop != null) {
                jcrop.destroy();
              }
              $cropper.find('img').remove();
              return canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
            };
            $cancelButton.on('click', function() {
              return $scope.$apply(finishCrop);
            });
            $scope.deleteImage = function(image) {
              var index;
              index = $scope.product.images.indexOf(image);
              $scope.product.images.splice(index, 1);
              return $scope.$parent.save();
            };
            return $scope.$on('product:save', function(event, product) {
              return uploadToS3(function(image) {
                $scope.image = image;
                $scope.product.images = [];
                $scope.product.images.push(image);
                return finishCrop();
              });
            });
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=s3-image-uploader.js.map
