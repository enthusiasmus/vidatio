"use strict"

app = angular.module "app", [
    "ui.router"
    "leaflet-directive"
    "app.controllers"
    "app.factories"
    "app.services"
    "app.factories"
    "app.directives"
    "app.filters"
    "app.config"
    "pascalprecht.translate"
    "ngToast"
    "ngAnimate"
    "ngResource"
    "ngSanitize"
    "ngCookies"
    "logglyLogger"
    "datePicker"
    "colorpicker.module"
    "angulartics"
    "angulartics.piwik"
    "bgf.paginateAnything"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "$cookieStore"
    "CONFIG"
    "$translate"
    "ngToast"
    ( $rootScope, $state, $stateParams, $http, $location, $cookieStore, CONFIG, $translate, ngToast) ->
        $rootScope.$state = $state
        $rootScope.hostUrl = "#{$location.protocol()}://#{$location.host()}"
        $rootScope.$stateParams = $stateParams

        if CONFIG.ENV is "production"
            $rootScope.apiBase = "#{CONFIG.API}"
            $rootScope.apiVersion = "/v0"
        else
            $rootScope.apiBase = "http://localhost:3000"
            $rootScope.apiVersion = "/v0"

        window.vidatio.log = new vidatio.Logger(CONFIG.TOKEN.LOGGLY, CONFIG.ENV is "develop")
        window.vidatio.helper = new window.vidatio.Helper()
        window.vidatio.recommender = new window.vidatio.Recommender()
        window.vidatio.geoParser = new window.vidatio.GeoParser()
        window.vidatio.visualization = new window.vidatio.Visualization()

        $rootScope.globals = $cookieStore.get( "globals" ) or {}
        if Object.keys($rootScope.globals).length > 0
            $rootScope.globals.authorized = true
            $http.defaults.headers.common["Authorization"] = "Basic " + $rootScope.globals.currentUser.authData

        $rootScope.history = []
        fromEditor = false

        $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
            $rootScope.absUrl = $location.absUrl()
            if toState.title?
                $rootScope.title = toState.title
            else
                $translate("SLOGAN").then (slogan) ->
                    $rootScope.title = slogan

            if $rootScope.history.length > 20
                $rootScope.history.splice(0, 1)

            $rootScope.history.push
                name: fromState.name
                params: fromParams

            if not $rootScope.authorized and $state.current.name is "app.share" or $state.current.name is "app.share.id"
                $rootScope.history.push
                    name: $state.current.name
                    params: fromParams

            userPages = ["app.login", "app.registration"]
            editorPages = ["app.editor", "app.editor.id", "app.share", "app.share.id"]
            editorAndUserPages = ["app.editor", "app.editor.id", "app.share", "app.share.id", "app.login", "app.registration"]

            # set boolean value true when user navigates from editor/share to login/registration
            if fromState.name in editorPages and toState.name in userPages
                fromEditor = true

            # show toast-message when user navigates otherwise than back to editor/share and was before on login/registration
            if fromEditor and fromState.name in userPages and toState.name not in editorAndUserPages
                showToastMessage('TOAST_MESSAGES.VIDATIO_CHANGES_SAVED')
                fromEditor = false
                return

            # show toast-message for users when editor- or share-page is leaved
            if fromState.name in editorPages and toState.name not in editorAndUserPages
                # don't show toast-message when user saves vidatio and continues to detailview
                if fromState.name is "app.share" and toState.name is "app.dataset"
                    return

                # show different toast-message when user goes back to import
                toastMessage = if toState.name is "app.import" then 'TOAST_MESSAGES.VIDATIO_CHANGES_SAVED_IMPORT' else 'TOAST_MESSAGES.VIDATIO_CHANGES_SAVED'
                showToastMessage(toastMessage)

            window.scrollTo 0, 0

        $translate([
            "D3PLUS.ERROR.ACCEPTED"
            "D3PLUS.ERROR.CONNECTIONS"
            "D3PLUS.ERROR.DATA"
            "D3PLUS.ERROR.DATAYEAR"
            "D3PLUS.ERROR.LIB"
            "D3PLUS.ERROR.LIBS"
            "D3PLUS.ERROR.METHOD"
            "D3PLUS.ERROR.METHODS"
            "D3PLUS.MESSAGE.DATA"
            "D3PLUS.MESSAGE.DRAW"
            "D3PLUS.MESSAGE.INITIALIZING"
            "D3PLUS.MESSAGE.LOADING"
            "D3PLUS.MESSAGE.TOOLTIPRESET"
            "D3PLUS.MESSAGE.UI"
        ]).then (translations) ->
            window.vidatio.d3PlusTranslations =
                message:
                    data: translations["D3PLUS.MESSAGE.DATA"]
                    draw: translations["D3PLUS.MESSAGE.DRAW"]
                    initializing: translations["D3PLUS.MESSAGE.INITIALIZING"]
                    loading: translations["D3PLUS.MESSAGE.LOADING"]
                    tooltipReset: translations["D3PLUS.MESSAGE.TOOLTIPRESET"]
                    ui: translations["D3PLUS.MESSAGE.UI"]
                error:
                    accepted: translations["D3PLUS.ERROR.ACCEPTED"]
                    connections: translations["D3PLUS.ERROR.CONNECTIONS"]
                    data: translations["D3PLUS.ERROR.DATA"]
                    dataYear: translations["D3PLUS.ERROR.DATAYEAR"]
                    lib: translations["D3PLUS.ERROR.LIB"]
                    libs: translations["D3PLUS.ERROR.LIBS"]
                    method: translations["D3PLUS.ERROR.METHOD"]
                    methods: translations["D3PLUS.ERROR.METHODS"]

        showToastMessage = (message) ->
            $translate(message)
            .then (translation) ->
                ngToast.create
                    content: translation
]

app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    "$translateProvider"
    "ngToastProvider"
    "LogglyLoggerProvider"
    "CONFIG"
    "$provide"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider, ngToast, LogglyLoggerProvider , CONFIG, $provide) ->
        $locationProvider.html5Mode true
        # Loggly Configuration
        # $log for angular
        LogglyLoggerProvider.inputToken CONFIG.TOKEN.LOGGLY if CONFIG.TOKEN.LOGGLY

        # Set the logging level for messages sent to Loggly.  'DEBUG' sends all log messages.
        # @method level
        LogglyLoggerProvider.level "DEBUG"

        # Send console error stack traces to Loggly.
        # @method sendConsoleErrors
        LogglyLoggerProvider.sendConsoleErrors true

        # Toggle logging to console. When set to false, messages will not be be passed along to the original $log methods.
        # This makes it easy to keep sending messages to Loggly in production without also sending them to the console.
        # @method logToConsole
        LogglyLoggerProvider.logToConsole false unless CONFIG.ENV is "develop"

        # $location.absUrl() is sent as a "url" key in the message object that's sent to loggly
        # @method includeUrl
        LogglyLoggerProvider.includeUrl  true

        # I18N
        $translateProvider.useSanitizeValueStrategy "escape"
        $translateProvider.useStaticFilesLoader
            prefix: "languages/"
            suffix: ".json"
        $translateProvider.preferredLanguage "de"
        $translateProvider.fallbackLanguage "de"

        # I18N for datepicker
        moment().locale "de"

        # overwrite default mFormat filter of datepicker module
        $provide.decorator 'mFormatFilter', ->
            (m, format, tz) ->
                if !moment.isMoment(m)
                    return ''
                if tz then moment.tz(m, tz).format(format) else m.format(format)

        ngToast.configure(
            animation: "slide"
            dismissButton: true
            additionalClasses: "custom-backgrounds"
        )

        $stateProvider
        # abstract state for language as parameter in URL
        .state "app",
            abstract: true
            url: "/{locale}"
            controller: "AppCtrl"
            template: "<ui-view/>"

        .state "app.index",
            url: "/"
            controller: "IndexCtrl"
            templateUrl: "index/index.html"

        .state "app.imprint",
            url: "/imprint"
            templateUrl: "imprint/imprint.html",
            title: "imprint"

        .state "app.profile",
            url: "/profile"
            templateUrl: "profile/profile.html"
            title: "profile"

        .state "app.dataset",
            url: "/vidatio/:id"
            templateUrl: "dataset/dataset.html"
            controller: "DatasetCtrl"
            title: "dataset"

        .state "app.registration",
            url: "/registration"
            templateUrl: "registration/registration.html"
            title: "registration"

        .state "app.login",
            url: "/login"
            templateUrl: "login/login.html"
            title: "login"

        .state "app.import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

        .state "app.embedding",
            url: "/embedding/:id"
            templateUrl: "embedding/embedding.html"
            controller: "EmbeddingCtrl"
            title: "embedding"

        .state "app.editor",
            url: "/editor"
            params:
                id: null
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        .state "app.editor.id",
            url: "/:id"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        .state "app.share",
            url: "/share"
            params:
                id: null
            templateUrl: "share/share.html"
            controller: "ShareCtrl"
            title: "share"

        .state "app.share.id",
            url: "/:id"
            templateUrl: "share/share.html"
            controller: "ShareCtrl"
            title: "share"

        .state "app.catalog",
            url: "/catalog?name&from&to&category&tags&myvidatios"
            templateUrl: "catalog/catalog.html"
            controller: "CatalogCtrl"
            title: "catalog"

        .state "app.fourofour",
            url: "/404"
            templateUrl: "404/404.html"
            title: "404"

        .state "app.terms",
            url: "/terms"
            templateUrl: "terms/terms.html"
            title: "terms"

        .state "app.team",
            url: "/team"
            templateUrl: "team/team.html"
            title: "team"

        # not match was found in the states before (e.g. no language was provided in the URL)
        .state "noMatch",
            url: '*path'
            onEnter: ($state, $stateParams) ->
                locale =
                    locale: $translateProvider.preferredLanguage()

                # iterate over all states and check if the requested url exists as a state; if not show 404-page
                for state in $state.get()
                    if $stateParams.path in ["/de", "/en"]
                        $state.go "app.index", locale
                        break
                    else if $stateParams.path is state.url
                        $state.go state.name, locale
                        break
                    else
                        $state.go "app.fourofour", locale
]
