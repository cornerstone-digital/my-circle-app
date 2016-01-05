(function() {
  if (typeof String.prototype.startsWith !== 'function') {
    String.prototype.startsWith = function(str) {
      return str.length > 0 && this.substring(0, str.length) === str;
    };
  }

  if (typeof String.prototype.truncateAt !== 'function') {
    String.prototype.truncateAt = function(length) {
      return this.substring(0, length);
    };
  }

}).call(this);

//# sourceMappingURL=stringUtils.js.map
