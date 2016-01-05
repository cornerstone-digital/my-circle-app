(function() {
  'use strict';

  /*
  Utility methods for dealing with colors
   */
  angular.module('smartRegisterApp').factory('Colors', [
    function() {
      return {

        /*
        Returns the lightness of a color from 0 to 1. Input must be a CSS 6 digit hex string.
        Adapted from toHSL in Less.js
         */
        lightness: function(hex) {
          var b, g, max, min, r;
          r = parseInt(hex.substr(1, 2), 16) / 255;
          g = parseInt(hex.substr(3, 2), 16) / 255;
          b = parseInt(hex.substr(5, 2), 16) / 255;
          max = Math.max(r, g, b);
          min = Math.min(r, g, b);
          return (max + min) / 2;
        },

        /*
        Based on Compass function
         */
        contrastColor: function(hex, light, dark, threshold) {
          if (light == null) {
            light = '#ffffff';
          }
          if (dark == null) {
            dark = '#333333';
          }
          if (threshold == null) {
            threshold = 0.4;
          }
          if (this.lightness(hex) < threshold) {
            return light;
          } else {
            return dark;
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=colors.js.map
