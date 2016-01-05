(function() {
  'use strict';
  angular.module('smartRegisterApp').config([
    '$routeProvider', '$locationProvider', '$httpProvider', function($routeProvider, $locationProvider, $httpProvider) {
      $routeProvider.when('/merchants', {
        templateUrl: 'views/merchant-list.html',
        controller: 'MerchantsCtrl',
        resolve: {
          merchants: [
            'MerchantService', function(MerchantService) {
              return MerchantService.getPagedList();
            }
          ],
          merchantlist: [
            'MerchantService', function(MerchantService) {
              return MerchantService.getList();
            }
          ]
        },
        title: 'Merchants',
        secured: true,
        role: 'PERM_PLATFORM_ADMINISTRATOR',
        fixedBar: true
      }).when('/merchants/add', {
        templateUrl: 'views/partials/merchants/merchant-edit-form.html',
        controller: 'MerchantFormCtrl',
        resolve: {
          merchant: [
            'MerchantService', function(MerchantService) {
              return MerchantService["new"]();
            }
          ],
          venues: [
            function() {
              return [];
            }
          ],
          employees: [
            'EmployeeService', '$route', function(EmployeeService, $route) {
              return [];
            }
          ]
        },
        title: 'Add Merchant',
        backUrl: '/merchants',
        secured: true,
        role: 'PERM_PLATFORM_ADMINISTRATOR',
        fixedBar: true
      }).when('/merchants/edit/:id', {
        templateUrl: 'views/partials/merchants/merchant-edit-form.html',
        controller: 'MerchantFormCtrl',
        resolve: {
          merchant: [
            'MerchantService', '$route', function(MerchantService, $route) {
              return MerchantService.getById($route.current.params.id, {
                full: true
              });
            }
          ],
          venues: [
            'VenueService', '$route', function(VenueService, $route) {
              return VenueService.getGridList($route.current.params.id).then(function(venues) {
                return _.sortBy(venues, "id");
              });
            }
          ],
          employees: [
            'EmployeeService', '$route', function(EmployeeService, $route) {
              return EmployeeService.getGridList($route.current.params.id).then(function(employees) {
                return _.sortBy(employees, "id");
              });
            }
          ]
        },
        title: 'Edit Merchant',
        backUrl: '/merchants',
        secured: true,
        role: 'PERM_PLATFORM_ADMINISTRATOR',
        fixedBar: true
      }).when('/merchant', {
        templateUrl: 'views/partials/merchants/merchant-edit-form.html',
        controller: 'MerchantFormCtrl',
        resolve: {
          merchant: [
            'MerchantService', 'Auth', function(MerchantService, Auth) {
              return MerchantService.getById(Auth.getMerchant().id, {
                full: true
              });
            }
          ],
          venues: [
            'VenueService', 'Auth', function(VenueService, Auth) {
              return VenueService.getGridList(Auth.getMerchant().id).then(function(venues) {
                return _.sortBy(venues, "id");
              });
            }
          ],
          employees: [
            'EmployeeService', 'Auth', function(EmployeeService, Auth) {
              return EmployeeService.getGridList(Auth.getMerchant().id).then(function(employees) {
                return _.sortBy(employees, "id");
              });
            }
          ]
        },
        title: 'Edit Merchant',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/venues', {
        templateUrl: 'views/venue-list.html',
        controller: 'VenuesCtrl',
        resolve: {
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getGridList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ]
        },
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/add', {
        templateUrl: 'views/partials/venues/venue-edit-form2.html',
        controller: 'VenueFormCtrl',
        resolve: {
          venue: [
            '$rootScope', 'VenueService', function($rootScope, VenueService) {
              return VenueService["new"]();
            }
          ],
          employees: [
            'VenueService', 'EmployeeService', '$route', function(VenueService, EmployeeService, $route) {
              return [];
            }
          ],
          discounts: [
            'VenueService', 'DiscountService', '$route', function(VenueService, DiscountService, $route) {
              return [];
            }
          ]
        },
        title: 'Add Venue',
        backUrl: '/venues',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/venues/edit/:id', {
        templateUrl: 'views/partials/venues/venue-edit-form2.html',
        controller: 'VenueFormCtrl',
        resolve: {
          venue: [
            'VenueService', '$route', function(VenueService, $route) {
              return VenueService.getById($route.current.params.id, {
                full: false
              });
            }
          ],
          employees: [
            'VenueService', 'EmployeeService', '$route', function(VenueService, EmployeeService, $route) {
              return VenueService.getById($route.current.params.id, {
                full: false
              }).then(function(venue) {
                return EmployeeService.getGridListByVenue(venue, {
                  full: true
                });
              });
            }
          ],
          discounts: [
            'VenueService', 'DiscountService', '$route', function(VenueService, DiscountService, $route) {
              return DiscountService.getList();
            }
          ]
        },
        title: 'Edit Venue',
        backUrl: '/venues',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/employees', {
        templateUrl: 'views/employee-list.html',
        controller: 'EmployeesCtrl',
        resolve: {
          venue: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getById($rootScope.credentials.venue.id, {
                full: false
              });
            }
          ],
          employees: [
            'EmployeeService', 'VenueService', '$rootScope', function(EmployeeService, VenueService, $rootScope) {
              return VenueService.getById($rootScope.credentials.venue.id, {
                full: false
              }).then(function(venue) {
                return EmployeeService.getGridListByVenue(venue);
              });
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ]
        },
        title: 'Staff',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/venues/:venueId/employees', {
        templateUrl: 'views/employee-list.html',
        controller: 'EmployeesCtrl',
        resolve: {
          venue: [
            'VenueService', '$route', function(VenueService, $route) {
              return VenueService.getById($route.current.params.venueId, {
                full: false
              });
            }
          ],
          employees: [
            'VenueService', 'EmployeeService', '$route', function(VenueService, EmployeeService, $route) {
              return VenueService.getById($route.current.params.venueId, {
                full: false
              }).then(function(venue) {
                return EmployeeService.getGridListByVenue(venue);
              });
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ]
        },
        title: 'Staff',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/venues/:venueId/employees/add', {
        templateUrl: 'views/partials/employees/employee-edit-form.html',
        controller: 'EmployeeFormCtrl',
        resolve: {
          employee: [
            'EmployeeService', function(EmployeeService) {
              return EmployeeService["new"]();
            }
          ],
          venues: [
            'VenueService', function(VenueService) {
              return VenueService.getList();
            }
          ],
          venue: [
            'VenueService', '$route', function(VenueService, $route) {
              return VenueService.getById($route.current.params.venueId, {
                full: false
              });
            }
          ]
        },
        title: 'Add Staff',
        backUrl: '/employees',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/employees/add', {
        templateUrl: 'views/partials/employees/employee-edit-form.html',
        controller: 'EmployeeFormCtrl',
        resolve: {
          employee: [
            'EmployeeService', function(EmployeeService) {
              return EmployeeService["new"]();
            }
          ],
          venues: [
            'VenueService', function(VenueService) {
              return VenueService.getList();
            }
          ],
          venue: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getById($rootScope.credentials.venue.id, {
                full: false
              });
            }
          ]
        },
        title: 'Add Staff',
        backUrl: '/employees',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/employees/edit/:id', {
        templateUrl: 'views/partials/employees/employee-edit-form.html',
        controller: 'EmployeeFormCtrl',
        resolve: {
          employee: [
            'EmployeeService', '$route', "Auth", function(EmployeeService, $route, Auth) {
              return EmployeeService.getById($route.current.params.id, {
                full: false
              }).then(function(employee) {
                employee["type"] = "Merchant";
                employee.merchantId = Auth.getMerchant().id;
                return employee;
              });
            }
          ],
          venues: [
            'VenueService', function(VenueService) {
              return VenueService.getList();
            }
          ],
          venue: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getById($rootScope.credentials.venue.id, {
                full: false
              });
            }
          ]
        },
        title: 'Edit Staff',
        backUrl: '/employees',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/venues/:venueId/employees/edit/:id', {
        templateUrl: 'views/partials/employees/employee-edit-form.html',
        controller: 'EmployeeFormCtrl',
        resolve: {
          employee: [
            'EmployeeService', '$route', function(EmployeeService, $route) {
              return EmployeeService.getByVenueId($route.current.params.id, $route.current.params.venueId, {
                full: false
              }).then(function(employee) {
                employee["type"] = "Venue";
                employee.venueId = $route.current.params.venueId;
                return employee;
              });
            }
          ],
          venues: [
            'VenueService', function(VenueService) {
              return VenueService.getList();
            }
          ],
          venue: [
            'VenueService', '$route', function(VenueService, $route) {
              return VenueService.getById($route.current.params.venueId);
            }
          ]
        },
        title: 'Edit Staff',
        backUrl: '/employees',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/products', {
        templateUrl: 'views/product-list2.html',
        controller: 'ProductsCtrl',
        resolve: {
          venue: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getById($rootScope.credentials.venue.id);
            }
          ],
          merchant: [
            'MerchantService', '$rootScope', function(MerchantService, $rootScope) {
              return MerchantService.getById($rootScope.credentials.merchant.id);
            }
          ],
          venues: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getList($rootScope.credentials.merchant.id);
            }
          ],
          categories: [
            'VenueService', '$rootScope', function(VenueService, $rootScope) {
              return VenueService.getVenueCategories($rootScope.credentials.venue.id);
            }
          ],
          products: [
            'VenueService', 'ProductService', '$rootScope', function(VenueService, ProductService, $rootScope) {
              return VenueService.getVenueCategories($rootScope.credentials.venue.id).then(function(response) {
                if (angular.isArray(response) && response.length) {
                  return ProductService.getListByCategory($rootScope.credentials.venue.id, response[0].id);
                } else {
                  return [];
                }
              });
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        title: 'Products',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/:id/products', {
        templateUrl: 'views/product-list2.html',
        controller: 'ProductsCtrl',
        resolve: {
          venue: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getById($route.current.params.id, {
                full: false
              });
            }
          ],
          merchant: [
            'MerchantService', '$rootScope', '$route', function(MerchantService, $rootScope, $route) {
              return MerchantService.getById($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          categories: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.id);
            }
          ],
          products: [
            'VenueService', 'ProductService', '$rootScope', '$route', function(VenueService, ProductService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.id).then(function(response) {
                if (angular.isArray(response) && response.length) {
                  return ProductService.getListByCategory($route.current.params.id, response[0].id);
                } else {
                  return [];
                }
              });
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        title: 'Products',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/:id/products/category/:categoryId', {
        templateUrl: 'views/product-list2.html',
        controller: 'ProductsCtrl',
        resolve: {
          venue: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getById($route.current.params.id, {
                full: false
              });
            }
          ],
          merchant: [
            'MerchantService', '$rootScope', '$route', function(MerchantService, $rootScope, $route) {
              return MerchantService.getById($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          categories: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.id);
            }
          ],
          products: [
            'VenueService', 'ProductService', '$rootScope', '$route', function(VenueService, ProductService, $rootScope, $route) {
              var categoryId;
              categoryId = $route.current.params.categoryId;
              if (categoryId) {
                return ProductService.getListByCategory($route.current.params.id, categoryId);
              } else {
                return VenueService.getVenueCategories($route.current.params.id).then(function(response) {
                  if (angular.isArray(response) && response.length) {
                    return ProductService.getListByCategory($route.current.params.id, response[0].id);
                  } else {
                    return [];
                  }
                });
              }
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        title: 'Products',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/:venueId/products/edit/:id', {
        templateUrl: 'views/partials/products/product-edit-form2.html',
        controller: "ProductFormCtrl",
        resolve: {
          product: [
            'ProductService', '$route', function(ProductService, $route) {
              return ProductService.getById($route.current.params.venueId, $route.current.params.id);
            }
          ],
          categories: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.venueId);
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        backUrl: '/products',
        title: 'Edit Product',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/:venueId/products/duplicate/:id', {
        templateUrl: 'views/partials/products/product-edit-form2.html',
        controller: "ProductFormCtrl",
        resolve: {
          product: [
            'ProductService', '$route', function(ProductService, $route) {
              return ProductService.getById($route.current.params.venueId, $route.current.params.id).then(function(product) {
                return ProductService.getListByCategory($route.current.params.venueId, product.category).then(function(products) {
                  var nonClonedProperties, productCount;
                  productCount = _.filter(products, function(it) {
                    return it.title.startsWith(product.title);
                  });
                  product.title = product.title + " #" + productCount.length;
                  delete product.id;
                  delete product.version;
                  delete product.created;
                  nonClonedProperties = ['id', 'version', 'created'];
                  _.forEach(product.images, function(image) {
                    var prop, _i, _len, _results;
                    _results = [];
                    for (_i = 0, _len = nonClonedProperties.length; _i < _len; _i++) {
                      prop = nonClonedProperties[_i];
                      _results.push(delete image[prop]);
                    }
                    return _results;
                  });
                  _.forEach(product.modifiers, function(modifier) {
                    var prop, _i, _len;
                    for (_i = 0, _len = nonClonedProperties.length; _i < _len; _i++) {
                      prop = nonClonedProperties[_i];
                      delete modifier[prop];
                    }
                    return _.forEach(modifier.variants, function(variant) {
                      var _j, _len1, _results;
                      _results = [];
                      for (_j = 0, _len1 = nonClonedProperties.length; _j < _len1; _j++) {
                        prop = nonClonedProperties[_j];
                        _results.push(delete variant[prop]);
                      }
                      return _results;
                    });
                  });
                  return product;
                });
              });
            }
          ],
          categories: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.venueId);
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        backUrl: '/products',
        title: 'Edit Product',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/venues/:venueId/products/category/:categoryId/add', {
        templateUrl: 'views/partials/products/product-edit-form2.html',
        controller: "ProductFormCtrl",
        resolve: {
          product: [
            'ProductService', '$route', function(ProductService, $route) {
              return ProductService["new"]();
            }
          ],
          categories: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueCategories($route.current.params.venueId);
            }
          ],
          sections: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getVenueSections($rootScope.credentials.venue.id);
            }
          ]
        },
        backUrl: '/products',
        title: 'Add Product',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/discounts', {
        templateUrl: 'views/discount-list.html',
        controller: 'DiscountsCtrl',
        resolve: {
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          discounts: [
            'DiscountService', function(DiscountService) {
              return DiscountService.getList();
            }
          ]
        },
        title: 'Discounts',
        secured: true,
        fixedBar: true
      }).when('/discounts/add', {
        templateUrl: 'views/partials/discounts/discount-edit-form.html',
        controller: 'DiscountFormCtrl',
        resolve: {
          discount: [
            'DiscountService', function(DiscountService) {
              return DiscountService["new"]();
            }
          ]
        },
        title: 'Add Discount',
        backUrl: '/discounts',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/discounts/edit/:id', {
        templateUrl: 'views/partials/discounts/discount-edit-form.html',
        controller: 'DiscountFormCtrl',
        resolve: {
          discount: [
            'DiscountService', '$route', function(DiscountService, $route) {
              return DiscountService.getById($route.current.params.id, {
                full: false
              });
            }
          ]
        },
        title: 'Edit Discount',
        backUrl: '/discounts',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR',
        fixedBar: true
      }).when('/reports', {
        templateUrl: 'views/smart-report.html',
        controller: 'SmartReportCtrl',
        resolve: {
          report: [
            '$location', 'Report', function($location, Report) {
              var params;
              params = {};
              if ($location.search()['pos.uuid'] != null) {
                params.pos = $location.search()['pos.uuid'];
              }
              return Report.get(params).$promise;
            }
          ],
          payments: [
            'Payments', (function(_this) {
              return function(Payments) {
                return Payments.query().$promise;
              };
            })(this)
          ]
        },
        title: 'smartReport',
        secured: true
      }).when('/reports/products', {
        templateUrl: 'views/product-report.html',
        controller: 'ProductReportCtrl',
        resolve: {
          report: [
            '$location', 'Report', function($location, Report) {
              var params;
              params = {};
              return Report.get(params).$promise;
            }
          ]
        },
        title: 'Product report',
        secured: true
      }).when('/reports/sold-stock', {
        templateUrl: 'views/sold-stock-report.html',
        controller: 'SoldStockReportCtrl',
        resolve: {
          report: [
            '$location', 'Report', function($location, Report) {
              var params;
              params = {
                type: 'SOLD_STOCK'
              };
              if ($location.search()['pos.uuid'] != null) {
                params.pos = $location.search()['pos.uuid'];
              }
              return Report.get(params).$promise;
            }
          ]
        },
        title: 'Sold stock report',
        secured: true
      }).when('/reports/compare', {
        templateUrl: 'views/comparison-report.html',
        controller: 'ComparisonReportCtrl',
        resolve: {
          report1: [
            'Report', function(Report) {
              var from, to;
              from = moment().subtract('days', 7).startOf('day');
              to = moment().subtract('days', 6).startOf('day');
              return Report.get({
                from: from.format('YYYY-MM-DDTHH:mm'),
                to: to.format('YYYY-MM-DDTHH:mm')
              }).$promise;
            }
          ],
          report2: [
            'Report', function(Report) {
              return Report.get().$promise;
            }
          ]
        },
        title: 'Comparison report',
        secured: true
      }).when('/reports/cpr', {
        templateUrl: 'views/cpr-report.html',
        controller: 'CPRReportCtrl',
        resolve: {
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          POSList: [
            '$location', 'POSService', '$rootScope', function($location, POSService, $rootScope) {
              var venueId, _ref;
              venueId = (_ref = $location.search()['venueId']) != null ? _ref : $rootScope.credentials.venue.id;
              return POSService.getList(venueId);
            }
          ],
          POSName: [
            '$location', function($location) {
              if ($location.search()['pos'] != null) {
                return $location.search()['pos'];
              }
            }
          ],
          venue: [
            '$location', '$rootScope', 'VenueService', function($location, $rootScope, VenueService) {
              if ($location.search()['venueId'] != null) {
                return VenueService.getById($location.search()['venueId'], {
                  full: false
                });
              } else {
                return $rootScope.credentials.venue;
              }
            }
          ],
          report: function() {
            return {};
          }
        },
        title: 'Closing POS Report',
        backUrl: '/reports/cpr-history',
        secured: true
      }).when('/reports/venue/:venueId/cpr/:id', {
        templateUrl: 'views/cpr-report.html',
        controller: 'CPRReportCtrl',
        resolve: {
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          POSList: [
            '$location', 'POSService', '$rootScope', function($location, POSService, $rootScope) {
              var venueId, _ref;
              venueId = (_ref = $location.search()['venueId']) != null ? _ref : $rootScope.credentials.venue.id;
              return POSService.getList(venueId);
            }
          ],
          POSName: [
            '$route', 'POSService', function($route, POSService) {
              return '';
            }
          ],
          venue: [
            '$route', 'VenueService', function($route, VenueService) {
              return VenueService.getById($route.current.params.venueId, {
                full: false
              });
            }
          ]
        },
        title: 'Closing POS Report',
        backUrl: '/reports/cpr-history',
        secured: true
      }).when('/reports/cpr-history', {
        templateUrl: 'views/cpr-history.html',
        controller: 'CPRReportHistoryCtrl',
        resolve: {
          CPRList: [
            'ReportsService', '$rootScope', function(ReportsService, $rootScope) {
              return ReportsService.getPagedCPRList();
            }
          ]
        },
        title: 'Closing POS Report History',
        secured: true
      }).when('/reports/sales-transaction-history', {
        templateUrl: 'views/sales-transaction-history.html',
        controller: 'SalesTransactionHistoryCtrl',
        title: 'Sales Transaction History',
        secured: true
      }).when('/timesheets', {
        templateUrl: 'views/timesheets.html',
        controller: 'TimesheetsCtrl',
        resolve: {
          startDate: function() {
            return moment().startOf('day');
          },
          endDate: function() {
            return moment().startOf('day');
          },
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ],
          timesheets: [
            'Timesheet', function(Timesheet) {
              return Timesheet.query({
                from: moment().startOf('day').format('YYYY-MM-DDTHH:mm'),
                to: moment().add('days', 1).startOf('day').format('YYYY-MM-DDTHH:mm')
              }).$promise;
            }
          ],
          shifts: [
            'Shift', function(Shift) {
              return Shift.query({
                from: moment().format('YYYY-MM-DD'),
                to: moment().add('days', 1).format('YYYY-MM-DD'),
                status: 'ENDED'
              }).$promise;
            }
          ]
        },
        title: 'Staff timesheets',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/social', {
        templateUrl: 'views/social.html',
        controller: 'SocialCtrl',
        resolve: {
          tools: [
            'Tool', function(Tool) {
              return Tool.query().$promise;
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ]
        },
        title: 'smartSocial',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/tools', {
        templateUrl: 'views/tools.html',
        controller: 'ToolsCtrl',
        resolve: {
          tools: [
            'Tool', function(Tool) {
              return Tool.query().$promise;
            }
          ],
          venues: [
            'VenueService', '$rootScope', '$route', function(VenueService, $rootScope, $route) {
              return VenueService.getList($rootScope.credentials.merchant.id, {
                full: false
              });
            }
          ]
        },
        title: 'smartTools',
        secured: true,
        role: 'PERM_MERCHANT_ADMINISTRATOR'
      }).when('/orders', {
        templateUrl: 'views/orders.html',
        controller: 'OrdersCtrl',
        resolve: {
          orders: [
            'Order', function(Order) {
              return Order.query({
                from: '1970-01-01T00:00'
              });
            }
          ]
        },
        title: 'smartOrders',
        secured: true,
        role: 'PERM_PLATFORM_ADMINISTRATOR'
      }).when('/login', {
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl',
        title: 'Login',
        secured: false
      }).when('/forgottenPassword', {
        templateUrl: 'views/forgotten-password.html',
        controller: 'ForgottenPasswordCtrl',
        title: 'Forgotten Password',
        secured: false
      }).when('/resetToken', {
        templateUrl: 'views/reset-token.html',
        controller: 'ResetTokenCtrl',
        title: 'Reset Password',
        resolve: {
          token: [
            '$location', function($location) {
              var token;
              if (($location.search()['r'] != null) || null) {
                return token = $location.search()['r'];
              }
            }
          ]
        },
        secured: false
      }).when('/invalid-env', {
        templateUrl: 'views/invalid-env.html',
        title: 'Invalid Environment'
      }).when('/not-found', {
        templateUrl: 'views/404.html',
        title: 'Not found'
      }).when('/forbidden', {
        templateUrl: 'views/403.html',
        title: 'Not found'
      }).when('/oauth/:provider/:token', {
        template: '<div class="alert alert-success">Storing <em>OAuth</em> token&hellip;</div>',
        controller: 'OAuthCtrl',
        resolve: {
          tools: [
            'Tool', function(Tool) {
              return Tool.query().$promise;
            }
          ]
        },
        secured: true
      }).when('/user-guide', {
        templateUrl: 'views/user-guide.html',
        title: 'User guide',
        secured: false
      }).when('/ui-tests', {
        templateUrl: 'views/ui-tests.html',
        controller: 'UITestsCtrl',
        title: 'UI Tests',
        secured: false
      }).when('/', {
        templateUrl: 'views/faq.html',
        secured: true
      }).otherwise({
        redirectTo: '/not-found'
      });
      return $httpProvider.interceptors.push('apiInterceptor');
    }
  ]);

}).call(this);

//# sourceMappingURL=routes.js.map
