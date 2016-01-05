if ( typeof String.prototype.startsWith != 'function' )
  String.prototype.startsWith = ( str ) ->
    return str.length > 0 && this.substring( 0, str.length ) == str


if ( typeof String.prototype.truncateAt != 'function' )
  String.prototype.truncateAt = ( length ) ->
    return this.substring(0, length)