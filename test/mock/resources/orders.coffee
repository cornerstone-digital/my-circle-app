'use strict'

angular.module('testFixtures')

  # this is an initial order
  .constant 'simpleOrder',
    id: "lsRPOeF"
    __v: 0
    basket:
      items: [
        id: "yidMG6j"
        state: "PAID"
        adjustment: -0.25
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "oxMI3Zd"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "Qzpbj7n"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Extra Shot,Take Away"
        total: 3
        taxTotal: 0.6000000000000001
        taxRate: 0.2
        subTotal: 2.4
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ]
    context:
      merchantId: "72WBWrM"
      venueId: "ZuH2XgQ"
      employeeId: "0000000"
    status: "FULL"
    updated: "2013-09-02T16:10:34.559Z"
    created: "2013-09-02T16:10:34.559Z"
    orderId: "ZvOxTFh"

  # the same order with a single item refunded
  .constant 'refundedOrder',
    id: "lsRPOeF"
    __v: 1
    basket:
      items: [
        id: "yidMG6j"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "oxMI3Zd"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "Qzpbj7n"
        state: "REFUNDED"
        adjustment: 0
        modifiers: "Medium,Regular,Extra Shot,Take Away"
        total: 3
        taxTotal: 0.6000000000000001
        taxRate: 0.2
        subTotal: 2.4
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ]
    context:
      merchantId: "72WBWrM"
      venueId: "ZuH2XgQ"
      employeeId: "0000000"
    status: "FULL"
    updated: "2013-09-02T16:16:00.631Z"
    created: "2013-09-02T16:10:34.559Z"
    orderId: "ZvOxTFh"

  # the same order with ALL items refunded
  .constant 'fullRefundOrder',
    __v: 2
    id: "lsRPOeF"
    basket:
      items: [
        id: "yidMG6j"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "oxMI3Zd"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Regular,Eat In"
        total: 2.5
        taxTotal: 0.5
        taxRate: 0.2
        subTotal: 2
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ,
        id: "Qzpbj7n"
        state: "PAID"
        adjustment: 0
        modifiers: "Medium,Regular,Extra Shot,Take Away"
        total: 3
        taxTotal: 0.6000000000000001
        taxRate: 0.2
        subTotal: 2.4
        category: "coffee"
        title: "Latte"
        productId: "vf1za7x"
        type: "PRODUCT"
      ]
    context:
      merchantId: "72WBWrM"
      venueId: "ZuH2XgQ"
      employeeId: "0000000"
    status: "REFUNDED"
    updated: "2013-09-02T16:17:15.744Z"
    created: "2013-09-02T16:10:34.559Z"
    orderId: "ZvOxTFh"
