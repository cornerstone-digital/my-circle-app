# Generated on 2013-12-02 using generator-angular 0.6.0-rc.2
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->

  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt

  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    yeoman:
      # configurable paths
      app: require("./bower.json").appPath or "app"
      dist: "dist"

    # Watches files for changes and runs tasks based on the changed files
    watch:
      coffee:
        files: ["<%= yeoman.app %>/scripts/**/*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      coffeeTest:
        files: ["test/spec/**/*.{coffee,litcoffee,coffee.md}"]
        tasks: [
          "newer:coffee:test"
          "karma"
        ]

      compass:
        files: ["<%= yeoman.app %>/styles/**/*.{scss,sass}"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      styles:
        files: ["<%= yeoman.app %>/styles/**/*.css"]
        tasks: [
          "newer:copy:styles"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.js"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"
        files: [
          "<%= yeoman.app %>/**/*.coffee"
          "<%= yeoman.app %>/**/*.html"
          ".tmp/styles/**/*.css"
          "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    # The actual grunt server settings
    connect:
      options:
        port: 9000
        hostname: "localhost"
        livereload: 35729
      livereload:
        options:
          open: false
          base: [
            ".tmp"
            "<%= yeoman.app %>"
          ]
      test:
        options:
          port: 9001
          base: [
            ".tmp"
            "test"
            "<%= yeoman.app %>"
          ]
      dist:
        options:
          base: "<%= yeoman.dist %>"

    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")
      all: ["Gruntfile.js"]

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]
      server: ".tmp"

    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]
      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "**/*.css"
          dest: ".tmp/styles/"
        ]

    # Automatically create custom modernizr
    modernizr:
      devFile: "<%= yeoman.app %>/bower_components/modernizr/modernizr.js"
      outputFile: "<%= yeoman.dist %>/bower_components/modernizr/modernizr.js"
      files: [
        "<%= yeoman.dist %>/scripts/**/*.js"
        "<%= yeoman.dist %>/styles/**/*.css"
        "!<%= yeoman.dist %>/scripts/vendor/*"
      ]

      extra:
        load: false
      uglify: true

    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "**/*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]
      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "**/*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        generatedImagesDir: ".tmp/images/generated"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: "<%= yeoman.app %>/bower_components"
        httpImagesPath: "/images"
        httpGeneratedImagesPath: "/images/generated"
        httpFontsPath: "/styles/fonts"
        relativeAssets: false
        assetCacheBuster: false
      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"
      server:
        options:
          debugInfo: true

    ngtemplates:
      dist:
        cwd: '<%= yeoman.app %>'
        src: 'views/**/*.html'
        dest: '.tmp/templates/templates.js'
        options:
          module: 'smartRegisterApp'
          htmlmin:
            collapseBooleanAttributes: true
            collapseWhitespace: true
            removeAttributeQuotes: false
            removeComments: true
            removeEmptyAttributes: false
            removeRedundantAttributes: true
            removeScriptTypeAttributes: true
            removeStyleLinkTypeAttributes: true

    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/**/*.js"
            "<%= yeoman.dist %>/styles/**/*.css"
            "<%= yeoman.dist %>/images/*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= yeoman.dist %>/styles/fonts/*"
          ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: ["<%= yeoman.app %>/*.html", "<%= yeoman.app %>/views/**/*.html"]
      options:
        dest: "<%= yeoman.dist %>"

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/**/*.html"]
      css: ["<%= yeoman.dist %>/styles/**/*.css"]
      options:
        assetsDirs: ["<%= yeoman.dist %>"]

    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "**/*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        options: {}
        # Optional configurations that you can uncomment to use
        # removeCommentsFromCDATA: true,
        # collapseBooleanAttributes: true,
        # removeAttributeQuotes: true,
        # removeRedundantAttributes: true,
        # useShortDoctype: true,
        # removeEmptyAttributes: true,
        # removeOptionalTags: true*/
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: [
            "*.html"
            "views/**/*.html"
          ]
          dest: "<%= yeoman.dist %>"
        ]

    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: "*.js"
          dest: ".tmp/concat/scripts"
        ]

    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "images/**/*.{webp}"
              "images/**/*"
              "fonts/*"
              "languages/**/*"
              "bower_components/angular-xeditable/**/*"
              "bower_components/angular-kendo/**/*"
              "bower_components/pdfmake/**/*"
              "bower_components/jquery/**/*"
              "bower_components/bootstrap-sass-official/vendor/assets/fonts/**/*"
              "external/**/*"
              "styles/BlueOpal/*"
              "styles/Silver/*"
              "styles/Flat/*"
              "styles/MyCircle1/*"
              "styles/textures/*"
              "styles/images/*"
            ]
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: ["generated/*"]
          }
        ]
      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "**/*.css"

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee:dist"
        "compass:server"
        "copy:styles"
      ]
      test: [
        "coffee"
        "compass"
        "copy:styles"
      ]
      dist: [
        "coffee"
        "compass:dist"
        "copy:styles"
        "imagemin"
        "svgmin"
        "htmlmin"
      ]

    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    cssmin: {
       dist: {
         files: {
           '<%= yeoman.dist %>/styles/main.css': [
             '.tmp/styles/**/*.css',
             '<%= yeoman.app %>/styles/**/*.css'
           ]
         }
       }
    },
    uglify: {
       dist: {
         files: {
           '<%= yeoman.dist %>/scripts/scripts.js': [
             '<%= yeoman.dist %>/scripts/scripts.js'
           ]
         }
       }
    },
    concat: {
       dist: {}
    },

    # Test settings
    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true

    rsync:
      options:
        args: ["-vahP --delete"]
        src: "./dist/"
      test:
        options:
          dest: "jetty-test-1.test.amazon.mycircleinc.net::merchant/"
      demo:
        options:
          dest: "jetty-demo-1.demo.amazon.mycircleinc.net::merchant/"
      staging:
        options:
          dest: "jetty-staging-1.staging.amazon.mycircleinc.net::merchant/"
      trial:
        options:
          dest: "jetty-trial-1.trial.amazon.mycircleinc.net::merchant/"
      live:
        options:
          dest: "jetty-live-1.live.amazon.mycircleinc.net::merchant/"

    "git-describe":
      options:
        template: "{%=tag%}-{%=object%}{%=dirty%}"
      dist: {}

  grunt.registerTask "tag-version", ->
    grunt.event.once "git-describe", (rev) ->
      grunt.log.writeln "Git revision: #{rev}"
      grunt.file.write "app/version.txt", rev.tag
      grunt.file.write "dist/version.txt", rev.tag
      grunt.file.write "app/git-version.txt", rev.object
      grunt.file.write "dist/git-version.txt", rev.object
    grunt.task.run "git-describe"

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "concurrent:server"
      "autoprefixer"
      "connect:livereload"
      "watch"
    ]

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"
    "autoprefixer"
    "connect:test"
    "karma"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "useminPrepare"
    "ngtemplates:dist"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngmin"
    "copy:dist"
    "tag-version"
    "cdnify"
    "cssmin"
    "uglify"
    "modernizr"
    "rev"
    "usemin"
  ]
  grunt.registerTask "release", (target) ->
    unless target?
      return grunt.util.error 'Specify a valid target, e.g. release:demo'

    build = grunt.option('build')

    if build
      grunt.task.run [
        "build"
      ]

    if target == "all"
      for t in ['test', 'staging', 'demo', 'trial', 'live']
        grunt.task.run [
          "rsync:#{t}"
        ]
    else if target == "internal"
      for t in ['test', 'staging', 'demo', 'trial']
        grunt.task.run [
          "rsync:#{t}"
        ]
    else
      grunt.task.run [
        "rsync:#{target}"
      ]

  grunt.registerTask "default", [
    "newer:jshint"
    "test"
    "build"
  ]
