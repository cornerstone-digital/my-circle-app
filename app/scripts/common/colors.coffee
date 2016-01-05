'use strict'

###
Utility methods for dealing with colors
###
angular.module('smartRegisterApp')
.factory 'Colors', [ ->
  ###
  Returns the lightness of a color from 0 to 1. Input must be a CSS 6 digit hex string.
  Adapted from toHSL in Less.js
  ###
  lightness: (hex) ->
    r = parseInt(hex.substr(1, 2), 16) / 255
    g = parseInt(hex.substr(3, 2), 16) / 255
    b = parseInt(hex.substr(5, 2), 16) / 255

    max = Math.max(r, g, b)
    min = Math.min(r, g, b)

    (max + min) / 2

  ###
  Based on Compass function
  ###
  contrastColor: (hex, light = '#ffffff', dark = '#333333', threshold = 0.4) ->
    if (@lightness(hex) < threshold) then light else dark
]
