'use strict'

describe 'Controller: Venues', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  VenuesCtrl = null
  $scope = null

  beforeEach inject ($controller, $rootScope) ->
    $scope = $rootScope.$new()
    VenuesCtrl = $controller 'VenuesCtrl', {
      $scope: $scope
      venues: [
          id: 1
          name: 'New York'
        ,
          id: 2
          name: 'Paris'
        ,
          id: 3
          name: 'Peckham'
      ]
    }

#  it 'should attach whatever venues it is given to the scope', ->
#    expect($scope.venues.length).toBe 3
