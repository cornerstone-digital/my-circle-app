'use strict'

angular.module('demoBackend')
  .constant 'authResponse',
    sessionId: "3fbd75cd-f51b-471d-a338-844107920310"
    merchantId: 2
    employee:
      id: 2
      version: 0
      firstname: "MyCircle"
      lastname: "Inc"
      email: "user@mycircleinc.com"
      locale: "en_GB"
      accountNonExpired: true
      accountNonLocked: true
      credentialsNonExpired: true
      enabled: true
      groups: [
        id: 40
        version: 0
        name: "PLATFORM_ADMINISTRATORS"
        locked: true
        authorities: [
          id: 50
          version: 0
          permission: "PERM_MERCHANT_ADMINISTRATOR"
          locked: true
          docType: "authority"
        ,
          id: 70
          version: 0
          permission: "PERM_MERCHANT_API"
          locked: true
          docType: "authority"
        ,
          id: 60
          version: 0
          permission: "PERM_VENUE_ADMINISTRATOR"
          locked: true
          docType: "authority"
        ]
        docType: "group"
      ]
      apiVersion: "3.0.0"
      created: "2013-12-13T10:00:00Z"
      displayName: "Demo User"
      docType: "employee"
      name: "MyCircle Inc"
