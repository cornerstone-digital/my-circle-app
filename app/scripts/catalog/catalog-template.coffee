'use strict'
angular.module('smartRegisterApp')
.constant 'catalogTemplate',
  Object.freeze
    categories: [
      title: "Bar Snacks"
      colour: "#314b78"
      index: 0
      products: [
        title: "Salted Peanuts"
        favourite: false
        price: 0.80
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ,
        title: "Crisps"
        favourite: false
        price: 0.75
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 1
        modifiers: [
          title: "Flavours"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Cheese & Onion"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Ready Salted"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Salt & Vinegar"
            isDefault: false
            priceDelta: 0.00
          ]
        ]
      ,
        title: "Pork Scratching Large"
        favourite: false
        price: 2.20
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 2
      ,
        title: "Pork Scratchings"
        favourite: false
        price: 1.99
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 3
      ,
        title: "Roast Peanuts"
        favourite: false
        price: 1.99
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 4
      ]
    ,
      title: "Beer"
      colour: "#487831"
      index: 1
      products: [
        title: "Budweiser"
        favourite: false
        price: 3.00
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ,
        title: "Peroni"
        favourite: false
        price: 3.00
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 1
      ]
    ,
      title: "Breakfast"
      colour: "#FF0000"
      index: 2
      products: [
        title: "Breakfast"
        favourite: false
        price: 0.00
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ,
        title: "Continental Breakfast"
        favourite: true
        price: 3.00
        tax: 0.20
        altPrice: 3.00
        altTax: 0.00
        index: 1
      ,
        title: "Eggs Benedict"
        favourite: false
        price: 6.50
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 2
      ,
        title: "Full English Breakfast"
        favourite: false
        price: 6.75
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 3
        modifiers: [
          title: "Bacon"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "1 Extra Bacon"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "2 Extra Bacon"
            isDefault: false
            priceDelta: 1.00
          ,
            title: "3 Extra Bacon"
            isDefault: false
            priceDelta: 1.50
          ]
        ,
          title: "Hash Brown"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "1 Extra Hash Bn"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "2 Extra Hash Bn"
            isDefault: false
            priceDelta: 1.00
          ,
            title: "3 Extra Hash Bn"
            isDefault: false
            priceDelta: 1.50
          ]
        ,
          title: "Sausage"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "1 Extra Sausage"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "2 Extra Sausage"
            isDefault: false
            priceDelta: 1.00
          ,
            title: "3 Extra Sausage"
            isDefault: false
            priceDelta: 1.50
          ]
        ]
      ]
    ,
      title: "Coffee"
      colour: "#487831"
      index: 3
      products: [
        title: "Americano"
        favourite: false
        price: 2.20
        tax: 0.00
        altPrice: 1.90
        altTax: 0.00
        index: 0
        modifiers: [
          title: "Size"
          allowMultiples: true
          allowNone: false
          variants: [
            title: "Large"
            isDefault: false
            priceDelta: 0.30
          ,
            title: "Regular"
            isDefault: true
            priceDelta: 0.00
          ]
        ]
      ,
        title: "Cappuccino"
        favourite: false
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 1
        modifiers: [
          title: "Extra Shots"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "One"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "Three"
            isDefault: false
            priceDelta: 1.50
          ,
            title: "Two"
            isDefault: false
            priceDelta: 1.00
          ]
        ,
          title: "Milk"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Full-Fat"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Semi-Skimmed"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Skimmed"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Soya"
            isDefault: false
            priceDelta: 0.50
          ]
        ,
          title: "Size"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "Large"
            isDefault: false
            priceDelta: 0.30
          ,
            title: "Medium"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Small"
            isDefault: false
            priceDelta: -0.30
          ]
        ,
          title: "Syrups"
          allowMultiples: true
          allowNone: true
          variants: [
            title: "Gingerbread"
            isDefault: false
            priceDelta: 0.20
          ,
            title: "Hazelnut"
            isDefault: false
            priceDelta: 0.20
          ,
            title: "Vanilla"
            isDefault: false
            priceDelta: 0.20
          ]
        ]
      ,
        title: "Coffee"
        favourite: true
        price: 0.80
        tax: 0.00
        altPrice: 0.80
        altTax: 0.00
        index: 2
      ,
        title: "Double Espresso"
        favourite: false
        price: 1.50
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 3
        modifiers: [
          title: "Shots"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Double Shot"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "Single Shot"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Triple Shot"
            isDefault: false
            priceDelta: 1.00
          ]
        ]
      ,
        title: "Espresso"
        favourite: false
        price: 1.65
        tax: 0.20
        altPrice: 1.50
        altTax: 0.20
        index: 4
        modifiers: [
          title: "Shots"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Double Shot"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "Single Shot"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Triple Shot"
            isDefault: false
            priceDelta: 1.00
          ]
        ]
      ,
        title: "Latte"
        favourite: true
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 5
        modifiers: [
          title: "Extra Shots"
          allowMultiples: false
          allowNone: true
          variants: [
            title: "One"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "Three"
            isDefault: false
            priceDelta: 1.50
          ,
            title: "Two"
            isDefault: false
            priceDelta: 1.00
          ]
        ,
          title: "Milk"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Full-Fat"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Semi-Skimmed"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Skimmed"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Soya"
            isDefault: false
            priceDelta: 0.50
          ]
        ,
          title: "Size"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Large"
            isDefault: false
            priceDelta: 0.30
          ,
            title: "Medium"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Small"
            isDefault: false
            priceDelta: -0.30
          ]
        ,
          title: "Syrups"
          allowMultiples: true
          allowNone: true
          variants: [
            title: "Gingerbread"
            isDefault: false
            priceDelta: 0.20
          ,
            title: "Hazelnut"
            isDefault: false
            priceDelta: 0.20
          ,
            title: "Vanilla"
            isDefault: false
            priceDelta: 0.20
          ]
        ]
      ,
        title: "Turkish Coffee"
        favourite: false
        price: 2.15
        tax: 0.00
        altPrice: 2.15
        altTax: 0.00
        index: 6
      ]
    ,
      title: "Cold Drinks"
      colour: "#0000ff"
      index: 4
      products: [
        title: "Bottled Water"
        favourite: false
        price: 1.10
        tax: 0.20
        altPrice: 1.00
        altTax: 0.00
        index: 0
      ,
        title: "Coca Cola"
        favourite: true
        price: 1.10
        tax: 0.20
        altPrice: 1.00
        altTax: 0.00
        index: 1
      ,
        title: "Fruit Juice"
        favourite: false
        price: 1.00
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 2
      ,
        title: "Milkshake"
        favourite: false
        price: 2.75
        tax: 0.20
        altPrice: 2.50
        altTax: 0.20
        index: 3
        modifiers: [
          title: "Flavouring"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Chocolate"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Strawberry"
            isDefault: false
            priceDelta: 0.00
          ,
            title: "Vanilla"
            isDefault: true
            priceDelta: 0.00
          ]
        ]
      ,
        title: "Sparkling water"
        favourite: false
        price: 0.80
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 4
      ,
        title: "Sprite"
        favourite: false
        price: 1.10
        tax: 0.20
        altPrice: 1.00
        altTax: 0.00
        index: 5
      ]
    ,
      title: "Lunch"
      colour: "#a1aa15"
      index: 5
      products: [
        title: "Salmon & Avocado Salad"
        favourite: false
        price: 8.80
        tax: 0.20
        altPrice: 8.00
        altTax: 0.20
        index: 0
      ,
        title: "Cheese & Pickle Sandwich"
        favourite: false
        price: 3.75
        tax: 0.15
        altPrice: 3.75
        altTax: 0.00
        index: 1
      ,
        title: "Chilli & Cheese Jacket"
        favourite: true
        price: 6.60
        tax: 0.20
        altPrice: 6.00
        altTax: 0.20
        index: 2
      ,
        title: "Classic Burger"
        favourite: true
        price: 7.15
        tax: 0.20
        altPrice: 6.50
        altTax: 0.20
        index: 3
        modifiers: [
          title: "Toppings"
          allowMultiples: true
          allowNone: true
          variants: [
            title: "Bacon"
            isDefault: false
            priceDelta: 0.50
          ,
            title: "Cheese"
            isDefault: false
            priceDelta: 0.50
          ]
        ]
      ,
        title: "Ham & Tomato Sandwich"
        favourite: false
        price: 3.85
        tax: 0.20
        altPrice: 2.50
        altTax: 0.00
        index: 4
        modifiers: [
          title: "Bread"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "White"
            isDefault: true
            priceDelta: 0.00
          ,
            title: "Wholegrain"
            isDefault: false
            priceDelta: 0.00
          ]
        ,
          title: "Sides"
          allowMultiples: true
          allowNone: true
          variants: [
            title: "Chips"
            isDefault: false
            priceDelta: 1.00
          ,
            title: "Crisps"
            isDefault: false
            priceDelta: 0.50
          ]
        ]
      ]
    ,
      title: "Pastries"
      colour: "#21aabd"
      index: 6
      products: [
        title: "Angle Cake"
        favourite: false
        price: 2.45
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 0
      ,
        title: "Carrot Cake"
        favourite: false
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.00
        index: 1
      ,
        title: "Chocolate Cake"
        favourite: false
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.00
        index: 2
      ,
        title: "Danish Pastry"
        favourite: true
        price: 1.75
        tax: 0.15
        altPrice: 1.55
        altTax: 0.00
        index: 3
      ,
        title: "Sponge Cake"
        favourite: false
        price: 2.45
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 4
      ,
        title: "Walnut Cake"
        favourite: false
        price: 3.25
        tax: 0.15
        altPrice: 3.10
        altTax: 0.00
        index: 5
      ]
    ,
      title: "Red Wine"
      colour: "#900b0b"
      index: 7
      products: [
        title: "Cabernet Sauvignon"
        favourite: true
        price: 10.95
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ,
        title: "Glass of House Red"
        favourite: false
        price: 2.30
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 1
      ,
        title: "Merlot"
        favourite: false
        price: 10.95
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 2
      ,
        title: "Rioja"
        favourite: false
        price: 9.95
        tax: 0.20
        altPrice: 9.95
        altTax: 0.20
        index: 3
      ]
    ,
      title: "Sandwiches"
      colour: "#872435"
      index: 8
      products: [
        title: "Cheese and Ham"
        favourite: false
        price: 2.30
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ]
    ,
      title: "Tea"
      colour: "#E36891"
      index: 9
      products: [
        title: "Tea"
        favourite: false
        price: 1.50
        tax: 0.00
        altPrice: 1.50
        altTax: 0.00
        index: 0
      ,
        title: "Darjeeling Earl Grey"
        favourite: false
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 1
      ,
        title: "English B'fast"
        favourite: true
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 2
      ,
        title: "Green Tea"
        favourite: false
        price: 0.00
        tax: 0.00
        altPrice: 0.00
        altTax: 0.00
        index: 3
      ,
        title: "Herbal Tea"
        favourite: false
        price: 2.20
        tax: 0.20
        altPrice: 2.00
        altTax: 0.20
        index: 4
      ,
        title: "Large Pot Yorkshire Tea"
        favourite: true
        price: 2.75
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 5
      ]
    ,
      title: "Today's Specials"
      colour: "#FF0000"
      index: 10
      products: [
        title: "Rainbow Trout"
        favourite: true
        price: 12.95
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ]
    ,
      title: "White Wine"
      colour: "#21aabd"
      index: 11
      products: [
        title: "Sauvignon Blanc"
        favourite: false
        price: 3.75
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 0
      ,
        title: "Chateau Verdignan"
        favourite: false
        price: 5.00
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 1
        modifiers: [
          title: "Size"
          allowMultiples: false
          allowNone: false
          variants: [
            title: "Bottle"
            isDefault: false
            priceDelta: 30.00
          ]
        ]
      ,
        title: "Merlot"
        favourite: false
        price: 10.95
        tax: 0.20
        altPrice: 0.00
        altTax: 0.00
        index: 2
      ]
    ]
