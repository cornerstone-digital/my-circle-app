angular.module('smartRegisterApp')
.factory 'ImageService', ['$http', '$rootScope', '$filter', 'Auth', 'ResourceNoPaging',($http, $rootScope, $filter, Auth, ResourceNoPaging) ->
#  $scope.folder = null
#  $scope.policy = null
#  $scope.policyBase64 = $filter('base64') $scope.policy
#  $scope.signature = $filter('hmacSha1') policyBase64, s3Config.secretKey

  getS3Config: ->
    ResourceNoPaging.one("platform").one("s3images").get()

  uploadToS3: (imageFile) ->
    imageUploader = $('.image-uploader')

    console.log imageFile

#  uploadToS3: (imageFile) ->
#    $http.get("api://api/platform/s3images").success (s3Config) ->
#      $scope.folder = 'products'
#      $scope.policy =
#        expiration: '2020-12-01T12:00:00.000Z'
#        conditions: [
#          {bucket: s3Config.bucketName}
#          ['starts-with', '$key', '']
#          {acl: 'public-read'}
#          {'success_action_status': '201'}
#          ['starts-with', '$Content-Type', 'image/']
#        ]
#      $scope.policyBase64 = $filter('base64') $scope.policy
#      $scope.signature = $filter('hmacSha1') policyBase64, s3Config.secretKey
#
#    file = imageFile
#    key = "#{folder}/#{Auth.getMerchant().id}/#{new Date().getTime()}-#{file.name}"
#
#    formData = new FormData()
#    formData.append 'key', key
#    formData.append 'acl', 'public-read'
#    formData.append 'success_action_status', '201'
#    formData.append 'Content-Type', file.type
#    formData.append 'AWSAccessKeyId', s3Config.accessKeyId
#    formData.append 'policy', policyBase64
#    formData.append 'signature', signature
#    formData.append 'file', getCroppedImage()
#
#    $http.post "https://#{s3Config.bucketName}.s3.amazonaws.com/", formData,
#      headers:
#        'Content-Type': `undefined` # allows browser to automatically set multipart/form-data
#      transformRequest: (data) -> data # prevents Angular stringifying the payload
#    .success (data, status, headers) ->
#      callback
#        filename: key
#        url: $(data).find('location').text()
]