'use strict'

angular.module('smartRegisterApp')

.filter('base64', [->
  (it) ->
    it = JSON.stringify(it) unless typeof it is 'string'
    CryptoJS.enc.Utf8.parse(it).toString(CryptoJS.enc.Base64)
])

.filter('hmacSha1', [->
  (it, passphrase) ->
    CryptoJS.HmacSHA1(it, passphrase).toString(CryptoJS.enc.Base64)
])

.filter('hmacSha256', [->
  (it, passphrase) ->
    CryptoJS.HmacSHA256(it, passphrase).toString(CryptoJS.enc.Base64)
])
