'use strict'

angular.module('smartRegisterApp')
.controller 'ProductFormCtrl', ['$rootScope', '$scope','$location', '$timeout', '$route', '$filter', '$http', 'product','categories', 'sections', 'Auth', 'ProductService','MessagingService', 'ValidationService', 'ImageService', ($rootScope, $scope, $location, $timeout, $route, $filter, $http, product, categories, sections, Auth, ProductService, MessagingService, ValidationService, ImageService ) ->

  $scope.product = product
  $scope.categories = categories
  $scope.sections = sections
  # IMAGE UPLOADER START
  $cropper = $('.image-cropper')
  jcrop = null
  $scope.s3Config = null
  folder = null
  signature = null

  ImageService.getS3Config().then((s3Config) ->
    $scope.s3Config = s3Config

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

    $scope.policyBase64 = $filter('base64') policy

    $scope.signature = $filter('hmacSha1') $scope.policyBase64, s3Config.secretKey
  )

  getCanvas = ->
    $('canvas').get(0)

  $scope.getImageFile = ->
    $('input.imageInput').get(0).files[0]

  $scope.getCroppedImage = ->
    mimeString = $scope.getImageFile().type
    dataURI = getCanvas().toDataURL(mimeString)
    byteString = atob(dataURI.split(',')[1])
    array = []
    array.push byteString.charCodeAt(i) for i in [0..byteString.length]
    new Blob [new Uint8Array(array)], type: mimeString

  $scope.updatePreview = (crop) ->
    context = getCanvas().getContext('2d')
    context.clearRect 0, 0, getCanvas().width, getCanvas().height
    context.fillStyle = '#ffffff'
    context.fill()
    context.drawImage($('.image-cropper img').get(0), crop.x, crop.y, crop.w, crop.h, 0, 0, getCanvas().width, getCanvas().height)

  $scope.imageChanged = ->
    reader = new FileReader()
    reader.onload = ->

      if jcrop?
        jcrop.destroy()
        $('.image-cropper img').remove()

      $img = $ '<img>',
        src: reader.result
      $('.image-cropper').append $img

      $img.Jcrop
        aspectRatio: 1.77
        minSize: [230, 130]
        setSelect: [0, 0, 230, 130]
        boxWidth: 400
        boxHeight: 400
        onChange: $scope.updatePreview
        onSelect: $scope.updatePreview
      , -> jcrop = @
    reader.readAsDataURL $scope.getImageFile()

  $scope.validateImageSize = (file) ->
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

  $scope.uploadToS3 = (callback) ->
    file = $scope.getImageFile()

    if angular.isDefined(file)
      key = "#{folder}/#{Auth.getMerchant().id}/#{new Date().getTime()}-#{file.name}"

      formData = new FormData()
      formData.append 'key', key
      formData.append 'acl', 'public-read'
      formData.append 'success_action_status', '201'
      formData.append 'Content-Type', file.type
      formData.append 'AWSAccessKeyId', $scope.s3Config.accessKeyId
      formData.append 'policy', $scope.policyBase64
      formData.append 'signature', $scope.signature
      formData.append 'file', $scope.getCroppedImage()

      $http.post "https://#{$scope.s3Config.bucketName}.s3.amazonaws.com/", formData,
        headers:
          'Content-Type': `undefined` # allows browser to automatically set multipart/form-data
        transformRequest: (data) -> data # prevents Angular stringifying the payload
      .success (data, status, headers) ->
        callback
          filename: key
          url: $(data).find('location').text()
    else
      callback()

  $scope.deleteImage = (image) ->
    index = $scope.product.images.indexOf(image)
    $scope.product.images.splice index, 1
    $scope.save()

  # END IMAGE UPLOADER

  $scope.back = ->
    $rootScope.backUrl = "/venues/#{$rootScope.credentials.venue.id}/products/category/#{$scope.product.category}"
    $rootScope.back()

  $scope.sectionOptions = {
    animation: false
    placeholder: "Select a section..."
    dataTextField: "name"
    dataValueField: "id"
    maxSelectedItems: 4
    dataSource: {
      data: $scope.sections
    }
    change: (event) ->
      $scope.sectionIds = this.value()
  }

  $scope.sectionIds = _.map(product.sections, (productSection) ->
    productSection.id
  )

  if $route.current.params?.categoryId?
    $scope.product.category = Number($route.current.params.categoryId)
  else
    $scope.product.category = Number($scope.product.category)

  $scope.product.modifiers = [] unless $scope.product.modifiers

  $timeout ->
    angular.element(document.querySelector(".nav-tabs")).find('a:first').tab('show')
    angular.element(document.querySelector(".k-dropdown")).on('keydown', (event) ->
      if event.keyCode == 9
        selectBox = angular.element(event.currentTarget).find('select:first')
        $scope.moveToNextTabIndex(event, selectBox)
    )
  , 100

  $scope.reset = ->
    MessagingService.resetMessages()
    ValidationService.reset()

    if $scope.product.id?
      ProductService.getById($rootScope.credentials?.venue?.id, $scope.product.id).then((response)->
        $scope.product = response
      )
    else
      $scope.product = ProductService.new()

  $scope.save = (reload) ->

    filteredSections = []
    angular.forEach $scope.sectionIds, (value, index) ->
      section = _.filter(sections, (section) ->
        section.id == value
      )
      filteredSections.push section

    $scope.product.sections = _.flatten(filteredSections)

    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate('Product')

    if(!MessagingService.hasMessages('Product').length)
      $scope.locked = true
      reload = false unless reload

      $scope.product.category = Number($scope.product.category)

      $scope.uploadToS3((image) ->
        console.log 'called back'
        if image
          $scope.product.images = []
          $scope.product.images.push(image)

        if $scope.product.id?
          $scope.product.sections = [] unless sections?
          $timeout ->
            ProductService.save($rootScope.credentials.venue.id, $scope.product).then((response) ->
              $scope.$emit 'product:updated', response
              $scope.locked = false

              if reload
                $scope.back()

            , (response) ->
              console.error 'update failed'
              $scope.locked = false
            )
          , 100
        else
          $timeout ->
            ProductService.save($rootScope.credentials.venue.id, $scope.product).then((response) ->
              $scope.$emit 'product:created', response
              $scope.locked = false

              if reload
                $scope.back()

            , (response) ->
              console.error response
              $scope.locked = false
            )
          , 100
      )

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

  $scope.showDataChangedMessage = ->
    MessagingService.resetMessages()
    message = MessagingService.createMessage("warning", "Your product data has changed. Don't forget to press the 'Save' button.", 'Venue')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('Venue')

  $scope.findNextElemByTabIndex = (tabIndex) ->
    matchedElement = angular.element( document.querySelector("[tabindex='#{tabIndex}']") )

    return matchedElement

  $scope.moveToNextTabIndex = ($event, $element) ->
    currentElem = $element
    nextElem = []

    # Find next available tabIndex
    if currentElem?.attrs?.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex)
    else if currentElem[0].attributes?.nexttabindex?
      nextElem = $scope.findNextElemByTabIndex(currentElem[0].attributes.nexttabindex.value)

    if currentElem.save?
      currentElem.save()
      currentElem.hide()

    if(nextElem.length)
      $timeout ->
        nextElem.click()
      , 10
]
