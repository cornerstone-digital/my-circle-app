'use strict'

angular.module('smartRegisterApp')
.constant('productImageSize', [->
  Object.freeze
    width: 230
    height: 130
])
.directive 's3ImageUploader', ['$http', '$filter', '$timeout', 'Config', 'Auth', 'ImageService', 'MessagingService', ($http, $filter, $timeout, Config, Auth, ImageService, MessagingService) ->
  replace: true
  restrict: 'E'
  scope: true
  templateUrl: 'views/partials/images/s3-image-uploader.html'
  link: ($scope, $element) ->
    $input = $element.find(':input')
    $cropButton = $element.find('button.crop')
    $cancelButton = $element.find('button.cancel')
    $deleteButton = $element.find('button.delete')
    $preview = $element.find('.image-preview')
    canvas = $preview.find('canvas').get(0)
    $cropper = $element.find('.image-cropper')
    jcrop = null

    folder = null
    signature = null

    ImageService.getS3Config().then((s3Config) ->
      folder = 'products'
      policy =
        expiration: '2020-12-01T12:00:00.000Z'
        conditions: [
          {bucket: s3Config.bucketName}
          ['starts-with', '$key', '']
          {acl: 'public-read'}
          {'success_action_status': '201'}
          ['starts-with', '$Content-Type', 'image/']
        ]
      policyBase64 = $filter('base64') policy
      signature = $filter('hmacSha1') policyBase64, s3Config.secretKey

      getFile = ->
        $input.get(0).files[0]

      getCroppedImage = ->
        mimeString = getFile().type
        dataURI = canvas.toDataURL(mimeString)
        byteString = atob(dataURI.split(',')[1])
        array = []
        array.push byteString.charCodeAt(i) for i in [0..byteString.length]
        new Blob [new Uint8Array(array)], type: mimeString

      updatePreview = (crop) ->
        context = canvas.getContext('2d')
        context.clearRect 0, 0, canvas.width, canvas.height
        context.fillStyle = '#ffffff'
        context.fill()
        context.drawImage($cropper.find('img').get(0), crop.x, crop.y, crop.w, crop.h, 0, 0, canvas.width, canvas.height)

      validateImageSize = (file) ->
        if file
          img = new Image()
          img.src = window.URL.createObjectURL(file)
          img.onload = ->
            width = img.naturalWidth
            height = img.naturalHeight
            window.URL.revokeObjectURL img.src

            if width >= 236 and height >= 136
              return true
            else
              error = MessagingService.createMessage('error', 'Images must be at least 236px wide by 136px high. Please choose a larger image.', 'Product')
              MessagingService.addMessage(error)
              return false

      $input.on 'change', ->
        isValid = validateImageSize(getFile())

        $timeout ->
          if isValid and !MessagingService.hasMessages('Product').length

            reader = new FileReader()
            reader.onload = ->

              if jcrop?
                jcrop.destroy()
                $cropper.find('img').remove()

              $img = $ '<img>',
                src: reader.result
              $cropper.append $img
              $img.Jcrop
                aspectRatio: 1.77
                minSize: [230, 130]
                setSelect: [0, 0, 230, 130]
                boxWidth: 400
                boxHeight: 400
                onChange: updatePreview
                onSelect: updatePreview
              , -> jcrop = @
            reader.readAsDataURL getFile()
        , 200

      uploadToS3 = (callback) ->
        file = getFile()
        if file?
          key = "#{folder}/#{Auth.getMerchant().id}/#{new Date().getTime()}-#{file.name}"

          formData = new FormData()
          formData.append 'key', key
          formData.append 'acl', 'public-read'
          formData.append 'success_action_status', '201'
          formData.append 'Content-Type', file.type
          formData.append 'AWSAccessKeyId', s3Config.accessKeyId
          formData.append 'policy', policyBase64
          formData.append 'signature', signature
          formData.append 'file', getCroppedImage()

          $http.post "https://#{s3Config.bucketName}.s3.amazonaws.com/", formData,
            headers:
              'Content-Type': `undefined` # allows browser to automatically set multipart/form-data
            transformRequest: (data) -> data # prevents Angular stringifying the payload
          .success (data, status, headers) ->
            callback
              filename: key
              url: $(data).find('location').text()

      deleteFromS3 = (image) ->
        bucket = new AWS.S3({params: {Bucket: s3Config.bucketName}})

        params =
          Bucket: s3Config.bucketName # required
          Key: image.url # required

        bucket.deleteObject(params, (err, data) ->
          if err?
            console.log err
          else
            console.log data
        )

      finishCrop = ->
        $input.val ''
        jcrop?.destroy()
        $cropper.find('img').remove()
        canvas.getContext('2d').clearRect 0, 0, canvas.width, canvas.height

      $cancelButton.on 'click', ->
        $scope.$apply finishCrop

      $scope.deleteImage = (image) ->
          index = $scope.product.images.indexOf(image)
          $scope.product.images.splice index, 1
          $scope.$parent.save()
#          deleteFromS3(image)

      $scope.$on 'product:save', (event, product) ->

        uploadToS3 (image) ->
          $scope.image = image
          $scope.product.images = []
          $scope.product.images.push(image)

          finishCrop()
    )
]
