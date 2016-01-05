'use strict'

angular.module('smartRegisterApp')
  .config(['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/merchants',
        templateUrl: 'views/merchant-list.html'
        controller: 'MerchantsCtrl'
        resolve:
          merchants: ['MerchantService', (MerchantService) ->
            MerchantService.getPagedList()
          ]
          merchantlist: ['MerchantService', (MerchantService) ->
            MerchantService.getList()
          ]
        title: 'Merchants'
        secured: true
        role: 'PERM_PLATFORM_ADMINISTRATOR'
        fixedBar: true
      .when '/merchants/add',
        templateUrl: 'views/partials/merchants/merchant-edit-form.html'
        controller: 'MerchantFormCtrl'
        resolve:
          merchant: ['MerchantService', (MerchantService) ->
            MerchantService.new()
          ]
          venues: [ ->
            []
          ]
          employees: ['EmployeeService', '$route', (EmployeeService, $route) ->
            []
          ]
        title: 'Add Merchant'
        backUrl: '/merchants'
        secured: true
        role: 'PERM_PLATFORM_ADMINISTRATOR'
        fixedBar: true
      .when '/merchants/edit/:id',
        templateUrl: 'views/partials/merchants/merchant-edit-form.html'
        controller: 'MerchantFormCtrl'
        resolve:
          merchant: ['MerchantService','$route', (MerchantService, $route) ->
            MerchantService.getById($route.current.params.id, {full: true})
          ]
          venues: ['VenueService', '$route', (VenueService, $route) ->

            VenueService.getGridList($route.current.params.id).then((venues) ->
              _.sortBy(venues, "id")
            )
          ]
          employees: ['EmployeeService', '$route', (EmployeeService, $route) ->
            EmployeeService.getGridList($route.current.params.id).then((employees) ->
              _.sortBy(employees, "id")
            )
          ]
        title: 'Edit Merchant'
        backUrl: '/merchants'
        secured: true
        role: 'PERM_PLATFORM_ADMINISTRATOR'
        fixedBar: true
      .when '/merchant',
        templateUrl: 'views/partials/merchants/merchant-edit-form.html'
        controller: 'MerchantFormCtrl'
        resolve:
          merchant: ['MerchantService','Auth', (MerchantService, Auth) ->
#            console.log Auth.getMerchant()
            MerchantService.getById(Auth.getMerchant().id, {full: true})
          ]
          venues: ['VenueService', 'Auth', (VenueService, Auth) ->

            VenueService.getGridList(Auth.getMerchant().id).then((venues) ->
              _.sortBy(venues, "id")
            )
          ]
          employees: ['EmployeeService', 'Auth', (EmployeeService, Auth) ->
            EmployeeService.getGridList(Auth.getMerchant().id).then((employees) ->
              _.sortBy(employees, "id")
            )
          ]
        title: 'Edit Merchant'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/venues',
        templateUrl: 'views/venue-list.html'
        controller: 'VenuesCtrl'
        resolve:
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getGridList($rootScope.credentials.merchant.id, {full: false})
          ]
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/add',
        templateUrl: 'views/partials/venues/venue-edit-form2.html'
        controller: 'VenueFormCtrl'
        resolve:
          venue: ['$rootScope', 'VenueService', ($rootScope, VenueService) ->
            VenueService.new()
          ]
          employees:['VenueService', 'EmployeeService', '$route', (VenueService, EmployeeService, $route) ->
            []
          ]
          discounts: ['VenueService', 'DiscountService', '$route', (VenueService, DiscountService, $route) ->
            []
          ]
        title: 'Add Venue'
        backUrl: '/venues'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/venues/edit/:id',
        templateUrl: 'views/partials/venues/venue-edit-form2.html'
        controller: 'VenueFormCtrl'
        resolve:
          venue: ['VenueService','$route', (VenueService, $route) ->
            VenueService.getById($route.current.params.id, {full: false})
          ]
          employees:['VenueService', 'EmployeeService', '$route', (VenueService, EmployeeService, $route) ->
            VenueService.getById($route.current.params.id, {full: false}).then((venue) ->
              EmployeeService.getGridListByVenue(venue, full: true)
            )
          ]
          discounts: ['VenueService', 'DiscountService', '$route', (VenueService, DiscountService, $route) ->
            DiscountService.getList()
          ]
        title: 'Edit Venue'
        backUrl: '/venues'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/employees',
        templateUrl: 'views/employee-list.html'
        controller: 'EmployeesCtrl'
        resolve:
          venue: ['VenueService', '$rootScope', (VenueService, $rootScope) ->
            VenueService.getById($rootScope.credentials.venue.id, {full: false})
          ]
          employees: ['EmployeeService','VenueService', '$rootScope', (EmployeeService, VenueService, $rootScope) ->
            VenueService.getById($rootScope.credentials.venue.id, {full: false}).then((venue) ->
              EmployeeService.getGridListByVenue(venue)
            )
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
        title: 'Staff'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true

      .when '/venues/:venueId/employees',
        templateUrl: 'views/employee-list.html'
        controller: 'EmployeesCtrl'
        resolve:
          venue: ['VenueService', '$route', (VenueService, $route) ->
            VenueService.getById($route.current.params.venueId, {full: false})
          ]
          employees: ['VenueService', 'EmployeeService','$route', (VenueService, EmployeeService, $route) ->
            VenueService.getById($route.current.params.venueId, {full: false}).then((venue) ->
              EmployeeService.getGridListByVenue(venue)
            )
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
        title: 'Staff'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/venues/:venueId/employees/add',
        templateUrl: 'views/partials/employees/employee-edit-form.html'
        controller: 'EmployeeFormCtrl'
        resolve:
          employee: ['EmployeeService', (EmployeeService) ->
            EmployeeService.new()
          ]
          venues: ['VenueService', (VenueService) ->
            VenueService.getList()
          ]
          venue: ['VenueService', '$route', (VenueService, $route) ->
            VenueService.getById($route.current.params.venueId, {full: false})
          ]
        title: 'Add Staff'
        backUrl: '/employees'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/employees/add',
        templateUrl: 'views/partials/employees/employee-edit-form.html'
        controller: 'EmployeeFormCtrl'
        resolve:
          employee: ['EmployeeService', (EmployeeService) ->
            EmployeeService.new()
          ]
          venues: ['VenueService', (VenueService) ->
            VenueService.getList()
          ]
          venue: ['VenueService', '$rootScope', (VenueService, $rootScope) ->
            VenueService.getById($rootScope.credentials.venue.id, {full: false})
          ]
        title: 'Add Staff'
        backUrl: '/employees'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/employees/edit/:id',
        templateUrl: 'views/partials/employees/employee-edit-form.html'
        controller: 'EmployeeFormCtrl'
        resolve:
          employee: ['EmployeeService','$route', "Auth", (EmployeeService, $route, Auth) ->
             EmployeeService.getById($route.current.params.id, {full: false}).then((employee) ->
               employee["type"] = "Merchant"
               employee.merchantId = Auth.getMerchant().id

               return employee
             )
          ]
          venues: ['VenueService', (VenueService) ->
            VenueService.getList()
          ]
          venue: ['VenueService', '$rootScope', (VenueService, $rootScope) ->
            VenueService.getById($rootScope.credentials.venue.id, {full: false})
          ]
        title: 'Edit Staff'
        backUrl: '/employees'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/venues/:venueId/employees/edit/:id',
        templateUrl: 'views/partials/employees/employee-edit-form.html'
        controller: 'EmployeeFormCtrl'
        resolve:
          employee: ['EmployeeService','$route', (EmployeeService, $route) ->
            EmployeeService.getByVenueId($route.current.params.id, $route.current.params.venueId, {full: false}).then((employee) ->
              employee["type"] = "Venue"
              employee.venueId = $route.current.params.venueId

              return employee
            )
          ]
          venues: ['VenueService', (VenueService) ->
            VenueService.getList()
          ]
          venue: ['VenueService','$route', (VenueService, $route) ->

            VenueService.getById($route.current.params.venueId)
          ]
        title: 'Edit Staff'
        backUrl: '/employees'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/products',
        templateUrl: 'views/product-list2.html'
        controller: 'ProductsCtrl'
        resolve:
          venue: ['VenueService','$rootScope', (VenueService, $rootScope) ->

            VenueService.getById($rootScope.credentials.venue.id)
          ]
          merchant: ['MerchantService','$rootScope', (MerchantService, $rootScope) ->
            MerchantService.getById($rootScope.credentials.merchant.id)
          ]
          venues: ['VenueService','$rootScope', (VenueService, $rootScope) ->
            VenueService.getList($rootScope.credentials.merchant.id)
          ]
          categories: ['VenueService','$rootScope', (VenueService, $rootScope) ->
            VenueService.getVenueCategories($rootScope.credentials.venue.id)
          ]
          products: ['VenueService', 'ProductService', '$rootScope', (VenueService, ProductService, $rootScope) ->
            VenueService.getVenueCategories($rootScope.credentials.venue.id).then((response)->
              if angular.isArray(response) and response.length
                ProductService.getListByCategory($rootScope.credentials.venue.id, response[0].id)
              else
                []
            )
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        title: 'Products'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/:id/products',
        templateUrl: 'views/product-list2.html'
        controller: 'ProductsCtrl'
        resolve:
          venue: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getById($route.current.params.id, {full: false})
          ]
          merchant: ['MerchantService','$rootScope', '$route', (MerchantService, $rootScope, $route) ->
            MerchantService.getById($rootScope.credentials.merchant.id, {full: false})
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          categories: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.id)
          ]
          products: ['VenueService', 'ProductService', '$rootScope', '$route', (VenueService, ProductService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.id).then((response)->
              if angular.isArray(response) and response.length
                ProductService.getListByCategory($route.current.params.id, response[0].id)
              else
                []
            )
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        title: 'Products'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/:id/products/category/:categoryId',
        templateUrl: 'views/product-list2.html'
        controller: 'ProductsCtrl'
        resolve:
          venue: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getById($route.current.params.id, {full: false})
          ]
          merchant: ['MerchantService','$rootScope', '$route', (MerchantService, $rootScope, $route) ->
            MerchantService.getById($rootScope.credentials.merchant.id, {full: false})
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          categories: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.id)
          ]
          products: ['VenueService', 'ProductService', '$rootScope', '$route', (VenueService, ProductService, $rootScope, $route) ->
            categoryId = $route.current.params.categoryId

            if categoryId
              ProductService.getListByCategory($route.current.params.id, categoryId)
            else
              VenueService.getVenueCategories($route.current.params.id).then((response)->
                if angular.isArray(response) and response.length
                  ProductService.getListByCategory($route.current.params.id, response[0].id)
                else
                  []
              )
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        title: 'Products'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/:venueId/products/edit/:id',
        templateUrl: 'views/partials/products/product-edit-form2.html'
        controller: "ProductFormCtrl"
        resolve:
          product: ['ProductService','$route', (ProductService, $route) ->
            ProductService.getById($route.current.params.venueId, $route.current.params.id)
          ]
          categories: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.venueId)
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        backUrl: '/products'
        title: 'Edit Product'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/:venueId/products/duplicate/:id',
        templateUrl: 'views/partials/products/product-edit-form2.html'
        controller: "ProductFormCtrl"
        resolve:
          product: ['ProductService','$route', (ProductService, $route) ->
            ProductService.getById($route.current.params.venueId, $route.current.params.id).then((product) ->

              ProductService.getListByCategory($route.current.params.venueId, product.category).then((products) ->

                productCount = _.filter products, (it) ->
                  return it.title.startsWith(product.title)

                product.title = product.title + " #" + productCount.length

                delete product.id
                delete product.version
                delete product.created

                nonClonedProperties = ['id', 'version', 'created']
                _.forEach product.images, (image) ->
                  delete image[prop] for prop in nonClonedProperties
                _.forEach product.modifiers, (modifier) ->
                  delete modifier[prop] for prop in nonClonedProperties
                  _.forEach modifier.variants, (variant) ->
                    delete variant[prop] for prop in nonClonedProperties

                return product
              )

            )
          ]
          categories: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.venueId)
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        backUrl: '/products'
        title: 'Edit Product'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/venues/:venueId/products/category/:categoryId/add',
        templateUrl: 'views/partials/products/product-edit-form2.html'
        controller: "ProductFormCtrl"
        resolve:
          product: ['ProductService','$route', (ProductService, $route) ->
            ProductService.new()
          ]
          categories: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueCategories($route.current.params.venueId)
          ]
          sections: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getVenueSections($rootScope.credentials.venue.id)
          ]
        backUrl: '/products'
        title: 'Add Product'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/discounts',
        templateUrl: 'views/discount-list.html'
        controller: 'DiscountsCtrl'
        resolve:
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          discounts: ['DiscountService', (DiscountService) ->
            DiscountService.getList()
          ]
        title: 'Discounts'
        secured: true
        fixedBar: true
      .when '/discounts/add',
        templateUrl: 'views/partials/discounts/discount-edit-form.html'
        controller: 'DiscountFormCtrl'
        resolve:
          discount: ['DiscountService', (DiscountService) ->
            DiscountService.new()
          ]
        title: 'Add Discount'
        backUrl: '/discounts'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/discounts/edit/:id',
        templateUrl: 'views/partials/discounts/discount-edit-form.html'
        controller: 'DiscountFormCtrl'
        resolve:
          discount: ['DiscountService','$route', (DiscountService, $route) ->
            DiscountService.getById($route.current.params.id, {full: false})
          ]
        title: 'Edit Discount'
        backUrl: '/discounts'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
        fixedBar: true
      .when '/reports',
        templateUrl: 'views/smart-report.html'
        controller: 'SmartReportCtrl'
        resolve:
          report: ['$location', 'Report', ($location, Report) ->
            params = {}
            params.pos = $location.search()['pos.uuid'] if $location.search()['pos.uuid']?
            Report.get(params).$promise

          ]
          payments: ['Payments', (Payments) =>
            Payments.query().$promise
          ]
        title: 'smartReport'
        secured: true
      .when '/reports/products',
        templateUrl: 'views/product-report.html'
        controller: 'ProductReportCtrl'
        resolve:
          report: ['$location', 'Report', ($location, Report) ->
            params = {}
#            params.pos = $location.search()['pos.uuid'] if $location.search()['pos.uuid']?
#            params.venueId = $location.search()['venueId'] if $location.search()['venueId']?
            Report.get(params).$promise
          ]

        title: 'Product report'
        secured: true
      .when '/reports/sold-stock',
        templateUrl: 'views/sold-stock-report.html'
        controller: 'SoldStockReportCtrl'
        resolve:
          report: ['$location', 'Report', ($location, Report) ->
            params =
              type: 'SOLD_STOCK'
            params.pos = $location.search()['pos.uuid'] if $location.search()['pos.uuid']?
            Report.get(params).$promise
          ]
        title: 'Sold stock report'
        secured: true
      .when '/reports/compare',
        templateUrl: 'views/comparison-report.html'
        controller: 'ComparisonReportCtrl'
        resolve:
          report1: ['Report', (Report) ->
            from = moment().subtract('days', 7).startOf('day')
            to = moment().subtract('days', 6).startOf('day')
            Report.get(from: from.format('YYYY-MM-DDTHH:mm'), to: to.format('YYYY-MM-DDTHH:mm')).$promise
          ]
          report2: ['Report', (Report) ->
            Report.get().$promise
          ]
        title: 'Comparison report'
        secured: true
      .when '/reports/cpr',
        templateUrl: 'views/cpr-report.html'
        controller: 'CPRReportCtrl'
        resolve:
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          POSList: ['$location', 'POSService','$rootScope', ($location, POSService, $rootScope) ->
            venueId = $location.search()['venueId'] ? $rootScope.credentials.venue.id
            POSService.getList(venueId)
          ]
          POSName: ['$location', ($location) ->
            $location.search()['pos'] if $location.search()['pos']?
          ]
          venue: ['$location', '$rootScope', 'VenueService', ($location, $rootScope, VenueService)->
            if $location.search()['venueId']?
              VenueService.getById($location.search()['venueId'], {full: false})
            else
              $rootScope.credentials.venue
          ]
          report: ->
            {}
        title: 'Closing POS Report'
        backUrl: '/reports/cpr-history'
        secured: true
      .when '/reports/venue/:venueId/cpr/:id',
        templateUrl: 'views/cpr-report.html'
        controller: 'CPRReportCtrl'
        resolve:
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          POSList: ['$location', 'POSService','$rootScope', ($location, POSService, $rootScope) ->
            venueId = $location.search()['venueId'] ? $rootScope.credentials.venue.id
            POSService.getList(venueId)
          ]
          POSName: ['$route', 'POSService', ($route, POSService) ->
            ''
          ]
          venue: ['$route', 'VenueService', ($route, VenueService)->
            VenueService.getById($route.current.params.venueId, {full: false})
          ]
        title: 'Closing POS Report'
        backUrl: '/reports/cpr-history'
        secured: true
      .when '/reports/cpr-history',
        templateUrl: 'views/cpr-history.html'
        controller: 'CPRReportHistoryCtrl'
        resolve:
          CPRList: ['ReportsService', '$rootScope', (ReportsService, $rootScope) ->
            ReportsService.getPagedCPRList()
          ]
        title: 'Closing POS Report History'
        secured: true
      .when '/reports/sales-transaction-history',
        templateUrl: 'views/sales-transaction-history.html'
        controller: 'SalesTransactionHistoryCtrl'
#        resolve:
#          SalesTRXHistoryList: ['ReportsService', '$rootScope', (ReportsService, $rootScope) ->
#            ReportsService.getPagedOrderList()
#          ]
        title: 'Sales Transaction History'
        secured: true
      .when '/timesheets',
        templateUrl: 'views/timesheets.html'
        controller: 'TimesheetsCtrl'
        resolve:
          startDate: -> moment().startOf 'day'
          endDate: -> moment().startOf 'day'
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
          timesheets: ['Timesheet', (Timesheet) ->
            Timesheet.query(from: moment().startOf('day').format('YYYY-MM-DDTHH:mm'), to: moment().add('days', 1).startOf('day').format('YYYY-MM-DDTHH:mm')).$promise
          ]
          shifts: ['Shift', (Shift) ->
            Shift.query(from: moment().format('YYYY-MM-DD'), to: moment().add('days', 1).format('YYYY-MM-DD'), status: 'ENDED').$promise
          ]
        title: 'Staff timesheets'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/social',
        templateUrl: 'views/social.html'
        controller: 'SocialCtrl'
        resolve:
          tools: ['Tool', (Tool) ->
            Tool.query().$promise
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
        title: 'smartSocial'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/tools',
        templateUrl: 'views/tools.html'
        controller: 'ToolsCtrl'
        resolve:
          tools: ['Tool', (Tool) ->
            Tool.query().$promise
          ]
          venues: ['VenueService','$rootScope', '$route', (VenueService, $rootScope, $route) ->
            VenueService.getList($rootScope.credentials.merchant.id, {full: false})
          ]
        title: 'smartTools'
        secured: true
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      .when '/orders',
        templateUrl: 'views/orders.html'
        controller: 'OrdersCtrl'
        resolve:
          orders: ['Order', (Order) ->
            Order.query from: '1970-01-01T00:00'
          ]
        title: 'smartOrders'
        secured: true
        role: 'PERM_PLATFORM_ADMINISTRATOR'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
        title: 'Login'
        secured: false
      .when '/forgottenPassword',
        templateUrl: 'views/forgotten-password.html'
        controller: 'ForgottenPasswordCtrl'
        title: 'Forgotten Password'
        secured: false
      .when '/resetToken',
        templateUrl: 'views/reset-token.html'
        controller: 'ResetTokenCtrl'
        title: 'Reset Password'
        resolve:
          token: ['$location', ($location) ->
            token = $location.search()['r'] if $location.search()['r']? or null
          ]
        secured: false
      .when '/invalid-env',
        templateUrl: 'views/invalid-env.html'
        title: 'Invalid Environment'
      .when '/not-found',
        templateUrl: 'views/404.html'
        title: 'Not found'
      .when '/forbidden',
        templateUrl: 'views/403.html'
        title: 'Not found'
      .when '/oauth/:provider/:token',
        template: '<div class="alert alert-success">Storing <em>OAuth</em> token&hellip;</div>'
        controller: 'OAuthCtrl'
        resolve:
          tools: ['Tool', (Tool) ->
            Tool.query().$promise
          ]
        secured: true
      .when '/user-guide',
        templateUrl: 'views/user-guide.html'
        title: 'User guide'
        secured: false
      .when '/ui-tests',
        templateUrl: 'views/ui-tests.html'
        controller: 'UITestsCtrl'
        title: 'UI Tests'
        secured: false
      .when '/',
        templateUrl: 'views/faq.html'
        secured: true

      .otherwise
        redirectTo: '/not-found'

    $httpProvider.interceptors.push 'apiInterceptor'
  ])
