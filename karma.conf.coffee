module.exports = (config) ->
    config.set

        # base path that will be used to resolve all patterns (eg. files, exclude)
        basePath: ""


        # frameworks to use
        # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ["jasmine-jquery", "jasmine"]

        # list of files / patterns to load in the browser
        files: [

            # third party libs
            "./bower_components/jquery/dist/jquery.js"
            "./bower_components/angular/angular.js"
            "./bower_components/angular-animate/angular-animate.min.js"
            "./bower_components/angular-leaflet-directive/dist/angular-leaflet-directive.js"
            "./bower_components/angular-loggly-logger/angular-loggly-logger.js"
            "./bower_components/angular-resource/angular-resource.min.js"
            "./bower_components/angular-sanitize/angular-sanitize.min.js"
            "./bower_components/angular-simple-logger/dist/angular-simple-logger.js"
            "./bower_components/angular-ui-router/release/angular-ui-router.js"
            "./bower_components/angular-cookies/angular-cookies.js"
            "./bower_components/canvg/dist/canvg.bundle.js"
            "./bower_components/d3/d3.js"
            "./bower_components/d3.parcoords.js/d3.parcoords.js"
            "./bower_components/flat-ui/dist/js/flat-ui.js"
            "./bower_components/video.js/dist/video.js"
            "./bower_components/handsontable/dist/handsontable.full.js"
            "./bower_components/html2canvas/build/html2canvas.js"
            "./bower_components/jPushMenu/js/jPushMenu.js"
            "./bower_components/loggly-jslogger/src/loggly.tracker.js"
            "./bower_components/leaflet/dist/leaflet-src.js"
            "./bower_components/moment/min/moment.min.js"
            "./bower_components/moment-timezone/builds/moment-timezone-with-data.min.js"
            "./bower_components/moment/locale/de.js"
            "./bower_components/angular-datepicker/dist/angular-datepicker.js"
            "./bower_components/ngToast/dist/ngToast.min.js"
            "./bower_components/papa-parse/papaparse.js"
            "./bower_components/shp/dist/shp.js"
            "./bower_components/angular-bootstrap-colorpicker/js/bootstrap-colorpicker-module.js"
            "./bower_components/select2/dist/js/select2.js"
            "./bower_components/angulartics/src/angulartics.js"
            "./bower_components/angulartics-piwik/src/angulartics-piwik.js"
            "./bower_components/bootbox.js/bootbox.js"
            "./bower_components/angular-paginate-anything/dist/angular-paginate-anything-tpls.js"

            # import angular mock - test dependency
            "./bower_components/angular-mocks/angular-mocks.js"

            # import angular mock - test dependency
            "./bower_components/angular-mocks/angular-mocks.js"

            # angular-translate
            "./bower_components/angular-translate/angular-translate.js"
            "./bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.js"

            #config
            "./app/statics/constants/config.json"

            # source files
            "./app/init-deps.coffee"
            "./app/app.coffee"
            "./app/app-controller.coffee"

            # includes test files already
            "./app/*/**/*.coffee"
            "./app/app-test.coffee"

        ]

        # list of files to exclude
        exclude: [
            # Bugfix PhantomJS
            # TypeError: 'undefined' is not an object (evaluating 'parent.prototype')
            "./app/components/visualization/bar/*.coffee"
            "./app/components/visualization/line/*.coffee"
            "./app/components/visualization/parallel/*.coffee"
            "./app/components/visualization/scatter/*.coffee"
            # Bugfix d3plus
            "./bower_components/d3plus/d3plus.js:"
        ]

        # preprocess matching files before serving them to the browser
        # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors:
            "**/*.coffee": ["coffee"]
            "**/*.json": ["ng-constant"]
            "**/!(*-test).coffee": ["coverage"]

        coffeePreprocessor:
            options:
                sourceMap: true

        # test results reporter to use
        # possible values: "dots", "progress"
        # available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ["progress", "coverage"]

        # web server port
        port: 9876

        # enable / disable colors in the output (reporters and logs)
        colors: true

        # level of logging
        # possible values:
        # - config.LOG_DISABLE
        # - config.LOG_ERROR
        # - config.LOG_WARN
        # - config.LOG_INFO
        # - config.LOG_DEBUG
        logLevel: config.LOG_INFO

        # enable / disable watching file and executing tests whenever any file changes
        # autoWatch: true

        # start these browsers
        # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: [
            "PhantomJS"
        ]

        # Continuous Integration mode
        # if true, Karma captures browsers, runs the tests and exits
        singleRun: false

        ngConstantPreprocessor:
            moduleName: "app.config"
            constantName: "CONFIG"

