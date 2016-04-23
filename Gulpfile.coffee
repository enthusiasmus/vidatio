gulp = require("gulp-help")(require("gulp"))

coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"

jade = require "gulp-jade"
templateCache = require "gulp-angular-templatecache"

stylus = require "gulp-stylus"
stylint = require "gulp-stylint"

karmaServer = require("karma").Server

browserSync = require("browser-sync").create()
reload = browserSync.reload
debug = require "gulp-debug"

concat = require "gulp-concat"
gif = require "gulp-if"
del = require "del"
rename = require "gulp-rename"
sourcemaps = require "gulp-sourcemaps"
util = require "gulp-util"
cached = require "gulp-cached"
shell = require "gulp-shell"
modRewrite = require "connect-modrewrite"
ngConstant = require "gulp-ng-constant"

uglify = require "gulp-uglify"
cleanCSS = require "gulp-clean-css"
ngAnnotate = require "gulp-ng-annotate"

DOC_FILES = [
    "./README.MD"
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/**/*.coffee"
    "!./app/**/*-test.coffee"
    "!./app/**/*-e2e.coffee"
]

COPY_FILES =
    img: [
        "./app/statics/assets/images/**/*.*"
    ]
    fonts: [
        "./app/statics/assets/fonts/*.*"
        "./bower_components/bootstrap/dist/fonts/*.*"
        "./bower_components/flat-ui/dist/fonts/**/*.*"
    ]
    lang: "./app/statics/languages/**/*.json"
    videos: "./app/statics/assets/videos/**/*"

BASEURL = "http://localhost:3123"

E2E_FILES = "./app/**/*-e2e.coffee"

APP_FILES = "./app/**/*.coffee"
STYL_FILES = "./app/**/*.styl"

BUILD =
    source:
        coffee: [
            "./app/init-deps.coffee"
            "./app/app.coffee"
            "./app/app-controller.coffee"
            "./app/**/*.coffee"
            "!./app/**/*-test.coffee"
            "!./app/**/*-e2e.coffee"
        ]
        stylus: [
            "./app/statics/master.styl"
        ]
        jade: [
            "./app/**/*.jade"
            "./app/**/*.jade"
        ]
        html: [
            "./build/html/**/*.html"
        ]
        config: [
            "./app/statics/constants/config.json"
        ]
    plugins:
        js: [
            "./bower_components/jquery/dist/jquery.js"
            "./bower_components/handsontable/dist/handsontable.full.js"
            "./bower_components/jPushMenu/js/jPushMenu.js"
            "./bower_components/angular/angular.js"
            "./bower_components/angular-ui-router/release/angular-ui-router.js"
            "./bower_components/angular-animate/angular-animate.min.js"
            "./bower_components/angular-resource/angular-resource.min.js"
            "./bower_components/angular-sanitize/angular-sanitize.min.js"
            "./bower_components/angular-leaflet-directive/dist/angular-leaflet-directive.js"
            "./bower_components/angular-simple-logger/dist/angular-simple-logger.js"
            "./bower_components/angular-loggly-logger/angular-loggly-logger.js"
            "./bower_components/angular-translate/angular-translate.js"
            "./bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.js"
            "./bower_components/angular-cookies/angular-cookies.js"
            "./bower_components/ngToast/dist/ngToast.min.js"
            "./bower_components/papa-parse/papaparse.js"
            "./bower_components/shp/dist/shp.js"
            "./bower_components/leaflet/dist/leaflet-src.js"
            "./bower_components/html2canvas/build/html2canvas.js"
            "./bower_components/c3/c3.js"
            "./bower_components/canvg/dist/canvg.bundle.js"
            "./bower_components/d3/d3.js"
            "./bower_components/d3plus/d3plus.js"
            "./bower_components/d3.parcoords.js/d3.parcoords.js"
            "./bower_components/flat-ui/dist/js/flat-ui.js"
            "./bower_components/video.js/dist/video.js"
            "./bower_components/moment/min/moment.min.js"
            "./bower_components/moment-timezone/builds/moment-timezone-with-data.min.js"
            "./bower_components/moment/locale/de.js"
            "./bower_components/angular-datepicker/dist/angular-datepicker.js"
            "./bower_components/loggly-jslogger/src/loggly.tracker.js"
            "./bower_components/angular-bootstrap-colorpicker/js/bootstrap-colorpicker-module.js"
            "./bower_components/pablo/pablo.js"
            "./bower_components/select2/dist/js/select2.js"
            "./bower_components/angulartics/src/angulartics.js"
            "./bower_components/angulartics-piwik/src/angulartics-piwik.js"
            "./bower_components/bootbox.js/bootbox.js"
            "./bower_components/angular-paginate-anything/dist/paginate-anything-tpls.js"
        ]
        css: [
            "./bower_components/bootstrap/dist/css/bootstrap.css"
            "./bower_components/flat-ui/dist/css/flat-ui.css"
            "./bower_components/ngToast/dist/ngToast.min.css"
            "./bower_components/ngToast/dist/ngToast-animations.min.css"
            "./bower_components/jPushMenu/css/jPushMenu.css"
            "./bower_components/handsontable/dist/handsontable.full.css"
            "./bower_components/leaflet/dist/leaflet.css"
            "./bower_components/d3.parcoords.js/d3.parcoords.css"
            "./bower_components/angular-datepicker/dist/angular-datepicker.css"
            "./bower_components/angular-bootstrap-colorpicker/css/colorpicker.css"
            "./bower_components/select2/dist/css/select2.css"
            "./bower_components/video.js/dist/video-js.css"
        ]
    dirs:
        out: "./build"
        js: "./build/js"
        css: "./build/css"
        html: "./build/html"
        fonts: "./build/fonts"
        images: "./build/images"
        videos: "./build/videos"
        lang: "./build/languages"
        docs: "./docs"
    module: "app"
    app: "app.js"
    plugin:
        js: "plugins.js"
        css: "plugins.css"

###
    MAIN TASKS
###

gulp.task "config:develop",
    "Setting up config for development environment", ->
        gulp.src BUILD.source.config
        .pipe ngConstant
            name: "app.config"
            merge: true
            constants:
                CONFIG:
                    ENV: "develop"
        .pipe gulp.dest BUILD.dirs.js

gulp.task "config:production",
    "Setting up config for development environment", ->
        gulp.src BUILD.source.config
        .pipe ngConstant
            name: "app.config"
            merge: true
            constants:
                CONFIG:
                    ENV: "production"
        .pipe gulp.dest BUILD.dirs.js

gulp.task "default",
    "Runs 'develop' and 'test'.",
    [
        "develop"
    ]

gulp.task "develop",
    "Watches/Build and Test the source files on change.",
    [
        "config:develop"
        "build"
        "test"
        "run"
    ]

gulp.task "tdd",
    "Watches/Build and Test the source files on change.",
    [
        "config:develop"
        "build"
        "test:tdd"
        "run"
    ]

gulp.task "dev",
    "Shorthand for develop.",
    [
        "develop"
    ]

gulp.task "production",
    "Builds the project for production to '#{BUILD.dirs.out}'.",
    [
        "copy"
        "config:production"
        "build:production:plugins:js"
        "build:production:plugins:css"
        "build:production:source:coffee"
        "build:production:source:stylus"
        "clean:html"
        "build:cache"
    ]

gulp.task "build",
    "Lints and builds the project to '#{BUILD.dirs.out}'.",
    [
        "copy"
        "build:plugins:js"
        "build:plugins:css"
        "build:source:coffee:watch"
        "build:source:stylus:watch"
        "build:source:jade:watch"
        "copy:languages:watch"
    ]
    ->
        reload()

gulp.task "test",
    "Starts and reruns all tests on change of test or source files.",
    (done) ->
        new karmaServer(
            configFile: __dirname + "/karma.conf.coffee"
            singleRun: true
        , done).start()

gulp.task "test:tdd",
    "Starts and reruns all tests on change of test or source files.",
    (done) ->
        new karmaServer(
            configFile: __dirname + "/karma.conf.coffee"
            singleRun: false
            autoWatch: true
        , done).start()

###
    LINTING
###
gulp.task "lint:coffee",
    "Lints all CoffeeScript source files.",
    ->
        gulp.src APP_FILES
        .pipe coffeelint()
        .pipe coffeelint.reporter()

gulp.task "lint:stylus",
    "Lints all Stylus source files.",
    ->
        gulp.src STYL_FILES
        .pipe cached "lint:stylus"
        .pipe stylint
            config: './.stylintrc'

###
    BUILDING PLUGINS
###
gulp.task "build:plugins:js",
    "Concatenates and saves '#{BUILD.plugin.js}' to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.plugins.js
        .pipe concat(BUILD.plugin.js)
        .pipe gulp.dest(BUILD.dirs.js)

gulp.task "build:production:plugins:js",
    "Uglifies, concatenates and saves '#{BUILD.plugin.js}' for production to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.plugins.js
        .pipe concat(BUILD.plugin.js)
        .pipe uglify()
        .pipe gulp.dest(BUILD.dirs.js)

gulp.task "build:plugins:css",
    "Concatenates and saves '#{BUILD.dirs.css}' to '#{BUILD.dirs.css}'.",
    ->
        gulp.src BUILD.plugins.css
        .pipe concat(BUILD.plugin.css)
        .pipe gulp.dest(BUILD.dirs.css)

gulp.task "build:production:plugins:css",
    "Concatenates and saves '#{BUILD.dirs.css}' to '#{BUILD.dirs.css}'.",
    ->
        gulp.src BUILD.plugins.css
        .pipe concat(BUILD.plugin.css)
        .pipe cleanCSS()
        .pipe gulp.dest(BUILD.dirs.css)

###
    BUILDING SOURCE
###
gulp.task "build:source:coffee",
    "Compiles and concatenates all coffeescript files to '#{BUILD.dirs.js}'.",
    [
        "lint:coffee"
    ]
    ->
        gulp.src BUILD.source.coffee
        .pipe sourcemaps.init()
        .pipe coffee().on "error", util.log
        .pipe concat(BUILD.app)
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.js)

gulp.task "build:production:source:coffee",
    "Compiles, uglifies and concatenates all coffeescript files for production to '#{BUILD.dirs.js}'.",
    []
    ->
        gulp.src BUILD.source.coffee
        .pipe coffee().on "error", util.log
        .pipe concat(BUILD.app)
        .pipe ngAnnotate()
        .pipe uglify({"mangle": true, "compress": true, "preserveComments": "license"})
        .pipe gulp.dest(BUILD.dirs.js)

gulp.task "build:source:stylus",
    "Compiles and concatenates all stylus files to '#{BUILD.dirs.css}'.",
    [
        "lint:stylus"
    ]
    ->
        gulp.src BUILD.source.stylus
        .pipe sourcemaps.init()
        .pipe stylus
            compress: true
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.css)

gulp.task "build:production:source:stylus",
    "Compiles and concatenates all stylus files for production to '#{BUILD.dirs.css}'.",
    []
    ->
        gulp.src BUILD.source.stylus
        .pipe stylus
            compress: true
        .pipe cleanCSS()
        .pipe gulp.dest(BUILD.dirs.css)

gulp.task "build:source:jade",
    "Compiles and concatenates all jade files to '#{BUILD.dirs.html}'.",
    ->
        gulp.src BUILD.source.jade
        .pipe jade
            pretty: true
        .pipe gulp.dest(BUILD.dirs.html)

gulp.task "build:copy",
    "Copies master.html to '#{BUILD.dirs.out}/static'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe gif "**/master.html", gulp.dest ( BUILD.dirs.out )

gulp.task "build:cache",
    "Caches all angular.js templates in '#{BUILD.dirs.js}'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe templateCache(module: BUILD.module)
        .pipe gulp.dest ( BUILD.dirs.js )

###
    COPY STATICS
###
gulp.task "copy",
    "Copy all assets to '#{BUILD.dirs.out}' dir.",
    [
        "copy:img"
        "copy:fonts"
        "copy:languages"
        "copy:videos"
    ]

gulp.task "copy:img",
    false,
    ->
        gulp.src COPY_FILES.img
        .pipe gulp.dest BUILD.dirs.images

gulp.task "copy:fonts",
    false,
    ->
        gulp.src COPY_FILES.fonts
        .pipe gif "**/flat-ui-icons-regular.*", rename (path) ->
            path.dirname = "/glyphicons"
        .pipe gif "**/lato*", rename (path) ->
            path.dirname = "/lato"
        .pipe gulp.dest BUILD.dirs.fonts

gulp.task "copy:languages",
    false,
    ->
        gulp.src COPY_FILES.lang
        .pipe gulp.dest BUILD.dirs.lang

gulp.task "copy:videos",
    false,
    ->
        gulp.src COPY_FILES.videos
        .pipe gulp.dest BUILD.dirs.videos

###
    CLEANING
###

gulp.task "clean",
    "Clear '#{BUILD.dirs.out}' and '#{BUILD.dirs.docs}' folder.",
    (cb) ->
        del [BUILD.dirs.out, BUILD.dirs.docs], -> cb null, []

gulp.task "clean:build",
    false,
    (cb) ->
        del BUILD.dirs.out, -> cb null, []

gulp.task "clean:docs",
    false,
    (cb) ->
        del BUILD.dirs.docs, -> cb null, []

gulp.task "clean:html",
    false,
    [
        "build:copy"
    ]
    (cb) ->
        del BUILD.dirs.html, -> cb null, []

###
    DOCS
###

gulp.task "docs",
    "Generates documentation in '#{BUILD.dirs.docs}' directory.",
    ["clean:docs"], shell.task "groc"


###
    BROWSERSYNC SERVER
###
gulp.task "run", "Serves the App.",
    [
        "build"
    ],
    ->
        browserSync.init
            server:
                baseDir: BUILD.dirs.out
                index: "/statics/master.html"
                middleware: [modRewrite(['!\\.\\w+$ /statics/master.html [L]'])]
            open: false
            port: 3123
            ui:
                port: 3124
                weinre: 3125
            logLevel: "info"
            notify: false
            logPrefix: "VIDATIO"

gulp.task "run:production", "Serves the App.",
    [],
    ->
        browserSync.init
            server:
                baseDir: BUILD.dirs.out
                index: "/statics/master.html"
                middleware: [modRewrite(['!\\.\\w+$ /statics/master.html [L]'])]
            open: false
            port: 3123
            ui:
                port: 3124
                weinre: 3125
            logLevel: "info"
            notify: false
            logPrefix: "VIDATIO"


###
    LIVE-RELOAD
###

gulp.task "build:source:coffee:reload",
    false,
    [
        "build:source:coffee"
    ]
    ->
        reload()


gulp.task "build:source:stylus:reload",
    false,
    [
        "build:source:stylus"
    ]
    ->
        reload()


gulp.task "build:source:jade:reload",
    false,
    [
        "clean:html"
        "build:cache"
    ]
    ->
        reload()

gulp.task "copy:languages:reload",
    false,
    [
        "copy:languages"
    ]
    ->
        reload()

###
    WATCHER
###

gulp.task "build:source:jade:watch",
    "Builds jade files from '#{BUILD.source.jade}' to '#{BUILD.dirs.out}/statics/master.html'.",
    [
        "clean:html"
        "build:cache"
    ]
    ->
        gulp.watch BUILD.source.jade, ["build:source:jade:reload"]

gulp.task "build:source:stylus:watch",
    "Builds stylus files from '#{BUILD.source.stylus}' to '#{BUILD.dirs.css}'.",
    [
        "build:source:stylus"
    ]
    ->
        gulp.watch STYL_FILES, ["build:source:stylus:reload"]

gulp.task "build:source:coffee:watch",
    "Builds coffeescript files from '#{BUILD.source.coffee}' to '#{BUILD.dirs.js}'.",
    [
        "build:source:coffee"
    ]
    ->
        gulp.watch BUILD.source.coffee, ["build:source:coffee:reload"]

gulp.task "copy:languages:watch",
    "Copies language files to '#{COPY_FILES.lang}' to '#{BUILD.dirs.lang}'.",
    [
        "copy:languages"
    ]
    ->
        gulp.watch COPY_FILES.lang, ["copy:languages:reload"]
