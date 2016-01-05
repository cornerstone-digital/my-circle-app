'use strict'

angular.module('testFixtures')
  .constant 'flatWhite',
    title: "Flat White"
    modifiers: [
      id: 1
      version: 0
      title: "Size"
      variants: [
        id: 1
        version: 0
        title: "Small"
        isDefault: false
        priceDelta: -0.2
      ,
        id: 2
        version: 0
        title: "Medium"
        isDefault: true
        priceDelta: 0
      ,
        id: 3
        version: 0
        title: "Large"
        isDefault: false
        priceDelta: 0.2
      ]
      allowNone: false
      allowMultiples: false
    ,
      id: 2
      version: 0
      title: "Milk"
      variants: [
        id: 4
        version: 0
        title: "Regular"
        isDefault: true
        priceDelta: 0
      ,
        id: 5
        version: 0
        title: "Soya"
        isDefault: false
        priceDelta: 0.5
      ]
      allowNone: false
      allowMultiples: false
    ]
    category: 1
    favourite: true
    index: 0
    favouriteIndex: 0
    tax: 0.2
    price: 2.5
    id: "8GWvQvU"

  .constant 'croissant',
    title: "Croissant"
    modifiers: []
    category: 5
    favourite: false
    index: 0
    favouriteIndex: 0
    tax: 0.2
    price: 1.75
    id: "dBkQ1dj"

  .constant 'bagel',
    title: "Bagel"
    modifiers: []
    category: 5
    favourite: false
    index: 0
    favouriteIndex: 0
    tax: 0.2
    price: 1.75
    id: "dBkQ1dk"

  .constant 'baconRoll',
    title: "Bacon Roll"
    modifiers: []
    category: 5
    favourite: true
    index: 0
    favouriteIndex: 0
    tax: 0.2
    price: 1.75
    id: "dBkQ1dl"
