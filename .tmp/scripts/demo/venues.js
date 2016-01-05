(function() {
  'use strict';
  angular.module('demoBackend').constant('venuesResponse', [
    {
      id: 2,
      version: 0,
      name: "myCircleInc Venue.",
      legalName: "myCircleInc Venue",
      companyNumber: "123456789010",
      vatNumber: "GB1234567890",
      locale: "en_GB",
      address: {
        id: 1,
        version: 0,
        line1: "Winchester House",
        line2: "259-269 Old Marylebone Road",
        city: "London",
        county: "Greater London",
        postCode: "NW1S 5RA",
        country: {
          id: 232,
          version: 0,
          alpha2Code: "GB",
          alpha3Code: "GBR",
          name: "United Kingdom",
          numericCode: 826,
          docType: "country"
        },
        addressFor: "ALL",
        apiVersion: "3.0.0",
        created: "2013-12-13T10:00:00Z",
        docType: "address"
      },
      apiVersion: "3.0.0",
      created: "2013-12-13T10:00:00Z",
      contacts: [
        {
          id: 2,
          version: 0,
          type: "EMAIL",
          value: "user@mycircleinc.com",
          apiVersion: "3.0.0",
          created: "2013-12-13T10:00:00Z",
          docType: "contact"
        }
      ],
      docType: "venue",
      currencyCode: "GBP",
      currencySymbol: "GBP"
    }
  ]);

}).call(this);

//# sourceMappingURL=venues.js.map
