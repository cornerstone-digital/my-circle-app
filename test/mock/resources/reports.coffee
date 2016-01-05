'use strict'

angular.module('testFixtures')
  .constant 'smartReport',
    dateRange:
      from: "2014-04-27T00:00:00Z"
      to: "2014-05-03T00:00:00Z"
    categoryReport:
      categories: [
        type: "PAYMENT"
        category: "Cakes/Pastries"
        count: 145
        total: 193.90
      ,
        type: "PAYMENT"
        category: "Ice cream"
        count: 1
        total: 3.20
      ,
        type: "PAYMENT"
        category: "Chocolate animal"
        count: 11
        total: 10.18
      ,
        type: "PAYMENT"
        category: "Sandwiches"
        count: 54
        total: 148.45
      ,
        type: "PAYMENT"
        category: "Toasties"
        count: 5
        total: 14.50
      ,
        type: "PAYMENT"
        category: "Rolls"
        count: 31
        total: 76.60
      ,
        type: "PAYMENT"
        category: "MANUAL"
        count: 238
        total: 715.35
      ,
        type: "PAYMENT"
        category: "Breakfast Menu"
        count: 20
        total: 12.40
      ,
        type: "PAYMENT"
        category: "Cold Drinks"
        count: 23
        total: 26.90
      ,
        type: "PAYMENT"
        category: "Salads"
        count: 2
        total: 9.00
      ,
        type: "PAYMENT"
        category: "Hot Drinks"
        count: 542
        total: 826.30
      ,
        type: "REFUND"
        category: "Hot Drinks"
        count: 1
        total: 1.20
      ]
    productReport:
      products: [
        type: "PAYMENT"
        title: "Tuna Mayo"
        count: 15
        total: 38.25
      ,
        type: "PAYMENT"
        title: "tomato"
        count: 3
        total: 0.60
      ,
        type: "PAYMENT"
        title: "Glass Water"
        count: 5
        total: 5.00
      ,
        type: "PAYMENT"
        title: "Parma ham bagel"
        count: 1
        total: 3.00
      ,
        type: "PAYMENT"
        title: "bread x2 "
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "Milkshake"
        count: 2
        total: 5.00
      ,
        type: "PAYMENT"
        title: "party"
        count: 1
        total: 120.00
      ,
        type: "PAYMENT"
        title: "honey"
        count: 1
        total: 0.20
      ,
        type: "PAYMENT"
        title: "Cinnamon bun"
        count: 8
        total: 12.00
      ,
        type: "PAYMENT"
        title: "sausage"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "Toast"
        count: 12
        total: 9.60
      ,
        type: "PAYMENT"
        title: "roll"
        count: 6
        total: 3.50
      ,
        type: "PAYMENT"
        title: "Can Soft Drink - Tango"
        count: 1
        total: 0.80
      ,
        type: "PAYMENT"
        title: "brown roll "
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "Tea"
        count: 61
        total: 73.20
      ,
        type: "PAYMENT"
        title: "bread"
        count: 4
        total: 1.20
      ,
        type: "PAYMENT"
        title: "Organic carrot cake"
        count: 4
        total: 10.00
      ,
        type: "PAYMENT"
        title: "role"
        count: 1
        total: 0.50
      ,
        type: "PAYMENT"
        title: "Cheese & Tomato"
        count: 1
        total: 2.90
      ,
        type: "PAYMENT"
        title: "chcolates"
        count: 3
        total: 14.24
      ,
        type: "PAYMENT"
        title: "veg soup"
        count: 6
        total: 24.00
      ,
        type: "PAYMENT"
        title: "....0.5"
        count: 1
        total: 0.00
      ,
        type: "PAYMENT"
        title: "deal of dayx2"
        count: 1
        total: 5.00
      ,
        type: "PAYMENT"
        title: "Dinosaurs"
        count: 8
        total: 7.60
      ,
        type: "PAYMENT"
        title: "Tom"
        count: 1
        total: 0.30
      ,
        type: "PAYMENT"
        title: "Bacon & egg"
        count: 2
        total: 5.00
      ,
        type: "PAYMENT"
        title: "chocs"
        count: 24
        total: 106.63
      ,
        type: "PAYMENT"
        title: "Can Soft Drink - Brands"
        count: 2
        total: 1.60
      ,
        type: "PAYMENT"
        title: "cheese sandwich"
        count: 1
        total: 2.40
      ,
        type: "PAYMENT"
        title: "Herbal Tea"
        count: 40
        total: 56.00
      ,
        type: "PAYMENT"
        title: "toast"
        count: 6
        total: 2.20
      ,
        type: "PAYMENT"
        title: "soup"
        count: 36
        total: 154.50
      ,
        type: "PAYMENT"
        title: "Flapjacks"
        count: 6
        total: 7.20
      ,
        type: "PAYMENT"
        title: "Hot chocolate"
        count: 40
        total: 72.00
      ,
        type: "PAYMENT"
        title: "Chelsea bun"
        count: 2
        total: 3.00
      ,
        type: "PAYMENT"
        title: "cheese roll"
        count: 1
        total: 2.40
      ,
        type: "PAYMENT"
        title: "2x boiled eggs"
        count: 1
        total: 1.60
      ,
        type: "PAYMENT"
        title: "3.95"
        count: 1
        total: 0.00
      ,
        type: "PAYMENT"
        title: "slice bread"
        count: 4
        total: 1.30
      ,
        type: "PAYMENT"
        title: "veg.soup"
        count: 1
        total: 4.00
      ,
        type: "PAYMENT"
        title: "Cappuccino"
        count: 78
        total: 132.60
      ,
        type: "PAYMENT"
        title: "Jam marmalade"
        count: 7
        total: 1.40
      ,
        type: "PAYMENT"
        title: "Biscuit"
        count: 6
        total: 4.20
      ,
        type: "PAYMENT"
        title: "Combo (3 scoops)"
        count: 1
        total: 3.20
      ,
        type: "PAYMENT"
        title: "Mocha"
        count: 8
        total: 13.60
      ,
        type: "PAYMENT"
        title: "sandwiche"
        count: 1
        total: 2.30
      ,
        type: "PAYMENT"
        title: "Belgian bun"
        count: 12
        total: 18.00
      ,
        type: "PAYMENT"
        title: "1.5 soup"
        count: 1
        total: 6.00
      ,
        type: "PAYMENT"
        title: "tuna salad"
        count: 1
        total: 4.50
      ,
        type: "PAYMENT"
        title: "toasted "
        count: 1
        total: 0.30
      ,
        type: "PAYMENT"
        title: "brioch"
        count: 12
        total: 9.28
      ,
        type: "PAYMENT"
        title: "pancake"
        count: 2
        total: 2.50
      ,
        type: "PAYMENT"
        title: "chicken and noodle soup"
        count: 1
        total: 5.00
      ,
        type: "PAYMENT"
        title: "chicken"
        count: 4
        total: 7.40
      ,
        type: "PAYMENT"
        title: "1/2 chicken soup"
        count: 1
        total: 3.00
      ,
        type: "PAYMENT"
        title: "chocolate umbrella"
        count: 1
        total: 0.90
      ,
        type: "PAYMENT"
        title: "Lion"
        count: 1
        total: 0.99
      ,
        type: "PAYMENT"
        title: "briochx2"
        count: 2
        total: 3.20
      ,
        type: "PAYMENT"
        title: "choc"
        count: 2
        total: 1.84
      ,
        type: "PAYMENT"
        title: "water"
        count: 2
        total: 1.56
      ,
        type: "PAYMENT"
        title: "Portuguese Cake"
        count: 33
        total: 39.60
      ,
        type: "PAYMENT"
        title: "Americano"
        count: 141
        total: 211.50
      ,
        type: "PAYMENT"
        title: "caldo verde"
        count: 1
        total: 4.00
      ,
        type: "PAYMENT"
        title: "strop"
        count: 1
        total: 0.50
      ,
        type: "PAYMENT"
        title: "Bacon"
        count: 5
        total: 12.20
      ,
        type: "PAYMENT"
        title: "Cheese & Pickle"
        count: 6
        total: 15.00
      ,
        type: "PAYMENT"
        title: "Juice"
        count: 8
        total: 8.00
      ,
        type: "PAYMENT"
        title: "Sausage"
        count: 1
        total: 2.20
      ,
        type: "PAYMENT"
        title: "Cheese and tomato"
        count: 5
        total: 12.85
      ,
        type: "PAYMENT"
        title: "Macchiato"
        count: 7
        total: 10.50
      ,
        type: "PAYMENT"
        title: "Egg Mayo"
        count: 3
        total: 7.05
      ,
        type: "PAYMENT"
        title: "Bacon & Sausage"
        count: 1
        total: 3.25
      ,
        type: "PAYMENT"
        title: "slice"
        count: 2
        total: 0.60
      ,
        type: "PAYMENT"
        title: "White roll"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "pancake cheese salad"
        count: 1
        total: 2.00
      ,
        type: "PAYMENT"
        title: "B.L.T"
        count: 3
        total: 8.70
      ,
        type: "PAYMENT"
        title: "Latte"
        count: 87
        total: 147.90
      ,
        type: "PAYMENT"
        title: "salad"
        count: 10
        total: 6.20
      ,
        type: "PAYMENT"
        title: "ham"
        count: 2
        total: 0.50
      ,
        type: "PAYMENT"
        title: "Ribena"
        count: 1
        total: 1.20
      ,
        type: "PAYMENT"
        title: "Double cheese onion"
        count: 3
        total: 8.00
      ,
        type: "PAYMENT"
        title: "mash Ellon and cream"
        count: 1
        total: 0.40
      ,
        type: "PAYMENT"
        title: "egg"
        count: 6
        total: 3.60
      ,
        type: "PAYMENT"
        title: "Cheese"
        count: 2
        total: 9.00
      ,
        type: "PAYMENT"
        title: "chcolates "
        count: 2
        total: 4.66
      ,
        type: "PAYMENT"
        title: "ext"
        count: 1
        total: 0.80
      ,
        type: "PAYMENT"
        title: "dinosaurs "
        count: 1
        total: 0.50
      ,
        type: "PAYMENT"
        title: "salas"
        count: 1
        total: 0.30
      ,
        type: "PAYMENT"
        title: "Lipton Tea"
        count: 3
        total: 3.60
      ,
        type: "PAYMENT"
        title: "cherry and almond cake"
        count: 1
        total: 1.20
      ,
        type: "PAYMENT"
        title: "Glass Soft Drink"
        count: 1
        total: 1.70
      ,
        type: "PAYMENT"
        title: "Double Espresso"
        count: 25
        total: 37.50
      ,
        type: "PAYMENT"
        title: "cherry almond cake"
        count: 1
        total: 1.20
      ,
        type: "PAYMENT"
        title: "Ham & Cheese"
        count: 4
        total: 11.60
      ,
        type: "PAYMENT"
        title: "Parma Ham"
        count: 1
        total: 3.20
      ,
        type: "PAYMENT"
        title: "toasted"
        count: 3
        total: 0.90
      ,
        type: "PAYMENT"
        title: "Cheese & pickle"
        count: 2
        total: 4.50
      ,
        type: "PAYMENT"
        title: "extra tom"
        count: 1
        total: 0.20
      ,
        type: "PAYMENT"
        title: "baby chino"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "Muffins"
        count: 15
        total: 22.50
      ,
        type: "PAYMENT"
        title: "Cheese & Ham"
        count: 24
        total: 65.05
      ,
        type: "PAYMENT"
        title: "bread x2"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "cheese and jam"
        count: 1
        total: 2.00
      ,
        type: "PAYMENT"
        title: "chicken soup "
        count: 2
        total: 10.00
      ,
        type: "PAYMENT"
        title: "chocolates"
        count: 3
        total: 12.44
      ,
        type: "PAYMENT"
        title: "Egg salad"
        count: 1
        total: 2.50
      ,
        type: "PAYMENT"
        title: "Prawn Mayo"
        count: 1
        total: 3.05
      ,
        type: "PAYMENT"
        title: "soup x2"
        count: 1
        total: 8.00
      ,
        type: "PAYMENT"
        title: "chcolate"
        count: 1
        total: 0.90
      ,
        type: "PAYMENT"
        title: "gem"
        count: 7
        total: 1.80
      ,
        type: "PAYMENT"
        title: "dread"
        count: 1
        total: 0.30
      ,
        type: "PAYMENT"
        title: "cheese and tomato roll"
        count: 1
        total: 2.45
      ,
        type: "PAYMENT"
        title: "kale soup"
        count: 6
        total: 24.00
      ,
        type: "PAYMENT"
        title: "Ham & Salad"
        count: 2
        total: 5.00
      ,
        type: "PAYMENT"
        title: "cheese and tom roll"
        count: 1
        total: 2.45
      ,
        type: "PAYMENT"
        title: "Sausage & Egg"
        count: 3
        total: 7.80
      ,
        type: "PAYMENT"
        title: "Cale soup"
        count: 1
        total: 4.00
      ,
        type: "PAYMENT"
        title: "Marzipan fruit"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "toasted bagel"
        count: 1
        total: 0.80
      ,
        type: "PAYMENT"
        title: "Porridge"
        count: 1
        total: 1.40
      ,
        type: "PAYMENT"
        title: "Apple pie"
        count: 6
        total: 15.00
      ,
        type: "PAYMENT"
        title: "Elephant"
        count: 1
        total: 0.99
      ,
        type: "PAYMENT"
        title: "brown roll"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "cheese"
        count: 1
        total: 0.60
      ,
        type: "PAYMENT"
        title: "chicken soup"
        count: 11
        total: 55.00
      ,
        type: "PAYMENT"
        title: "Waffle"
        count: 6
        total: 6.00
      ,
        type: "PAYMENT"
        title: "mash mellows"
        count: 1
        total: 0.20
      ,
        type: "PAYMENT"
        title: "pitta"
        count: 4
        total: 1.60
      ,
        type: "PAYMENT"
        title: "slice toast"
        count: 4
        total: 1.60
      ,
        type: "PAYMENT"
        title: "Espresso"
        count: 55
        total: 71.50
      ,
        type: "PAYMENT"
        title: "Chicken & Salad"
        count: 6
        total: 19.20
      ,
        type: "PAYMENT"
        title: "Plain Croissant"
        count: 47
        total: 56.40
      ,
        type: "PAYMENT"
        title: "bred"
        count: 1
        total: 1.75
      ,
        type: "PAYMENT"
        title: "Ham & salad"
        count: 1
        total: 2.25
      ,
        type: "PAYMENT"
        title: "tomatoe"
        count: 1
        total: 0.20
      ,
        type: "PAYMENT"
        title: "chocholate"
        count: 8
        total: 52.80
      ,
        type: "PAYMENT"
        title: "let ice"
        count: 1
        total: 0.25
      ,
        type: "PAYMENT"
        title: "soup caldo verde"
        count: 1
        total: 4.00
      ,
        type: "PAYMENT"
        title: "cake "
        count: 1
        total: 0.80
      ,
        type: "PAYMENT"
        title: "sweet corn "
        count: 1
        total: 0.30
      ,
        type: "REFUND"
        title: "Americano"
        count: 1
        total: 1.20
      ]
    paymentReport: {}
    vatReport:
      vatSummary: [
        vatSummaryDetails: [
          type: "PAYMENT"
          taxRate: 0.2
          total: 123.53
        ,
          type: "PAYMENT"
          taxRate: 0.15
          total: 4
        ]
      ,
        vatSummaryDetails: [
          type: "REFUND"
          taxRate: 0.2
          total: 0
        ,
          type: "REFUND"
          taxRate: 0.15
          total: 1
        ]
      ]
    zReport:
      summary: [
        type: "REFUND"
        paymentType: "CASH"
        count: 1
        total: 1.20
        average: 1.20
        max: 1.20
        min: 1.20
      ,
        type: "REFUND"
        paymentType: "CARD"
        count: 0
        total: 0.00
        average: 0.00
        max: 0.00
        min: 0.00
      ,
        type: "PAYMENT"
        paymentType: "CARD"
        count: 42
        total: 413.18
        average: 9.84
        max: 159.30
        min: 1.00
      ,
        type: "PAYMENT"
        paymentType: "CASH"
        count: 409
        total: 1623.60
        average: 3.97
        max: 25.67
        min: 0.66
      ]
