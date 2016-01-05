(function() {
  angular.module('smartRegisterApp').factory('ImageService', [
    '$http', '$rootScope', '$filter', 'Auth', 'ResourceNoPaging', function($http, $rootScope, $filter, Auth, ResourceNoPaging) {
      return {
        getS3Config: function() {
          return ResourceNoPaging.one("platform").one("s3images").get();
        },
        uploadToS3: function(imageFile) {
          var imageUploader;
          imageUploader = $('.image-uploader');
          return console.log(imageFile);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=image-service.js.map
