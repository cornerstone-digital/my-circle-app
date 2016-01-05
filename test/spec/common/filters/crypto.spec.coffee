'use strict'

describe 'Crypto filters', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  aString = 'a string'
  anObject =
    foo: 'bar'
    x: 1

  describe 'base64', ->

    base64 = null

    beforeEach inject ($filter) ->
      base64 = $filter 'base64'

    it 'should base64 encode a string', ->
      encoded = base64(aString)
      expect(atob(encoded)).toBe aString

    it 'should base64 encode an object', ->
      encoded = base64(anObject)
      decoded = JSON.parse(atob(encoded))
      expect(decoded.foo).toBe anObject.foo
      expect(decoded.x).toBe anObject.x

  describe 'hmacSha1', ->

    hmacSha1 = null

    beforeEach inject ($filter) ->
      hmacSha1 = $filter 'hmacSha1'

    it 'should encrypt a string', ->
      # this is a crappy a=a test but HMAC is one way so not sure what else makes sense
      encrypted = hmacSha1(aString, 'pa55w0rd')
      expect(encrypted).toBe CryptoJS.HmacSHA1(aString, 'pa55w0rd').toString(CryptoJS.enc.Base64)

  describe 'hmacSha256', ->

    hmacSha256 = null

    beforeEach inject ($filter) ->
      hmacSha256 = $filter 'hmacSha256'

    it 'should encrypt a string', ->
      # this is a crappy a=a test but HMAC is one way so not sure what else makes sense
      encrypted = hmacSha256(aString, 'pa55w0rd')
      expect(encrypted).toBe CryptoJS.HmacSHA256(aString, 'pa55w0rd').toString(CryptoJS.enc.Base64)
