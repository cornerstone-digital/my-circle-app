// Karma configuration

module.exports = function(config) {
  config.set({
    // base path, that will be used to resolve files and exclude
    basePath: '',

    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
    files: [
      'app/bower_components/jquery/jquery.js',
      'app/bower_components/fastclick/lib/fastclick.js',
      'app/bower_components/lodash/dist/lodash.js',
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-resource/angular-resource.js',
      'app/bower_components/angular-animate/angular-animate.js',
      'app/bower_components/angular-mocks/angular-mocks.js',
      'app/bower_components/angular-cookies/angular-cookies.min.js',
      'app/bower_components/angular-localization/angular-localization.js',
      'app/bower_components/spin.js/spin.js',
      'app/bower_components/angular-spinner/angular-spinner.min.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/alert.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/button.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/dropdown.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tab.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/transition.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/modal.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tooltip.js',
      'app/bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/popover.js',
      'app/bower_components/jquery-ui/ui/jquery.ui.core.js',
      'app/bower_components/jquery-ui/ui/jquery.ui.widget.js',
      'app/bower_components/jquery-ui/ui/jquery.ui.mouse.js',
      'app/bower_components/jquery-ui/ui/jquery.ui.sortable.js',
      'app/bower_components/switchery/dist/switchery.js',
      'app/bower_components/ng-switchery/src/ng-switchery.js',
      'app/bower_components/crypto-js/rollups/hmac-sha1.js',
      'app/bower_components/crypto-js/rollups/hmac-sha256.js',
      'app/bower_components/crypto-js/components/enc-base64-min.js',
      'app/bower_components/momentjs/moment.js',
      'app/bower_components/oauth.io/dist/oauth.min.js',
      'app/bower_components/restangular/dist/restangular.js',
      'app/bower_components/jquery.jqplot.1.0.8r1250.tar.gz/jquery.jqplot.js',
      'app/bower_components/jquery.jqplot.1.0.8r1250.tar.gz/plugins/jqplot.barRenderer.js',
      'app/bower_components/jquery.jqplot.1.0.8r1250.tar.gz/plugins/jqplot.categoryAxisRenderer.js',
      'app/bower_components/jquery.jqplot.1.0.8r1250.tar.gz/plugins/jqplot.pointLabels.js',
      'app/bower_components/angular-bootstrap/ui-bootstrap.min.js',
      'app/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js',
      'app/bower_components/angular-ui/build/angular-ui.min.js',
      'app/bower_components/angular-xeditable/dist/js/xeditable.js',
      'app/external/widgets/telerik.kendoui.professional/js/kendo.all.min.js',
      'app/bower_components/angular-kendo/build/angular-kendo.min.js',
      'app/scripts/app.coffee',
      'app/scripts/**/_module.coffee',
      'app/scripts/**/*.coffee',
      'test/*.coffee',
      'test/mock/*.coffee',
      'test/mock/**/*.coffee',
      'test/spec/**/*.coffee',
      'app/views/**/*.html'
    ],

    preprocessors: {
      '**/*.coffee': 'coffee',
      'app/views/**/*.html': 'ng-html2js'
    },

    ngHtml2JsPreprocessor: {
      // strip this from the file path
      stripPrefix: 'app/'
      // prepend this to the
      // prependPrefix: 'served/',

      // or define a custom transform function
      // cacheIdFromPath: function(filepath) {
      //   return cacheId;
      // },

      // setting this option will create only a single module that contains templates
      // from all the files, so you can load them all with module('foo')
      // moduleName: 'foo'
    },

    // list of files to exclude
    exclude: [
      'app/scripts/demo/*.coffee'
    ],

    // test results reporter to use
    // possible values: dots || progress || growl
    reporters: ['progress'],

    // web server port
    port: 8080,

    // cli runner port
    runnerPort: 9100,

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: false,

    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],

    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 5000,

    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false,
    reporters: ['dots', 'junit'],
    junitReporter: {
      outputFile: 'test-results.xml'
    }
  });
};
