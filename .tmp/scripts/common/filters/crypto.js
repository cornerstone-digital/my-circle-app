(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('base64', [
    function() {
      return function(it) {
        if (typeof it !== 'string') {
          it = JSON.stringify(it);
        }
        return CryptoJS.enc.Utf8.parse(it).toString(CryptoJS.enc.Base64);
      };
    }
  ]).filter('hmacSha1', [
    function() {
      return function(it, passphrase) {
        return CryptoJS.HmacSHA1(it, passphrase).toString(CryptoJS.enc.Base64);
      };
    }
  ]).filter('hmacSha256', [
    function() {
      return function(it, passphrase) {
        return CryptoJS.HmacSHA256(it, passphrase).toString(CryptoJS.enc.Base64);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=crypto.js.map
