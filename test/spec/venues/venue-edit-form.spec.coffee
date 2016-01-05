'use strict'

describe 'Directive: venueEditForm', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/partials/venues/venue-edit-form.html', 'views/faq.html', 'views/login.html'

  Venue = null
  $scope = null
  $element = null

  beforeEach inject (_Venue_, $rootScope, $compile) ->
    Venue = _Venue_

    $element = angular.element '<venue-edit-form></venue-edit-form>'
    $element = $compile($element) $rootScope
    $rootScope.$digest()

    $scope = $element.scope()

  describe 'creating a venue', ->

    beforeEach ->
      $scope.$broadcast 'venue:create'

    it 'creates a new phone contact', ->
      expect($scope.contact.id).toBeUndefined()
      expect($scope.contact.type).toBe 'PHONE'

    it 'adds the new contact to the list attached to the venue', ->
      expect($scope.venue.contacts.length).toBe 1
      expect($scope.venue.contacts[0]).toBe $scope.contact

  describe 'editing a venue', ->

    describe 'that has a phone contact already', ->

      emailContact = null
      phoneContact = null

      beforeEach ->
        emailContact =
          id: 1
          type: 'EMAIL'
          value: 'al.coholic@mycircleinc.com'

        phoneContact =
          id: 2
          type: 'PHONE'
          value: '0205556969'

        venue = new Venue
          contacts: [emailContact, phoneContact]

        $scope.$broadcast 'venue:edit', venue

      it 'selects the phone contact', ->
        expect($scope.contact).toEqual phoneContact
        expect($scope.contact).not.toBe phoneContact

    describe 'that does not currently have a phone contact', ->

      beforeEach ->
        venue = new Venue
          contacts: [
            id: 1
            type: 'EMAIL'
            value: 'al.coholic@mycircleinc.com'
          ]

        $scope.$broadcast 'venue:edit', venue

      it 'creates a new phone contact', ->
        expect($scope.contact.id).toBeUndefined()
        expect($scope.contact.type).toBe 'PHONE'

      it 'adds the new contact to the list attached to the venue', ->
        expect($scope.venue.contacts.length).toBe 2
        expect($scope.venue.contacts[1]).toBe $scope.contact

      describe 'entering a contact phone number', ->

        phoneNumber = null

        beforeEach ->
          phoneNumber = '0205556969'

          $element.find(':input[name=tel]').val(phoneNumber).trigger 'input'

        it 'updates the contacts array of the venue', ->
          expect($scope.venue.contacts[1].value).toBe phoneNumber

    describe 'that does not currently have any contacts', ->

      beforeEach ->
        venue = new Venue()

        $scope.$broadcast 'venue:edit', venue

      it 'creates a new phone contact', ->
        expect($scope.contact.id).toBeUndefined()
        expect($scope.contact.type).toBe 'PHONE'

      it 'adds the new contact to the list attached to the venue', ->
        expect($scope.venue.contacts.length).toBe 1
        expect($scope.venue.contacts[0]).toBe $scope.contact

      describe 'entering a contact phone number', ->

        phoneNumber = null

        beforeEach ->
          phoneNumber = '0205556969'

          $element.find(':input[name=tel]').val(phoneNumber).trigger 'input'

        it 'updates the contacts array of the venue', ->
          expect($scope.venue.contacts[0].value).toBe phoneNumber
