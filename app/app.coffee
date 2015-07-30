# Animals App
# ===========
"use strict"

app = angular.module "app", [
    "ngCookies"
    "ngResource"
    "ui.router"
    "app.controllers"
    "app.services"
    "app.directives"
    "app.filters"
    "leaflet-directive"
    "ngAnimate"
    "pascalprecht.translate"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "AuthenticationService"
    "UserService"
    ( $rootScope, $state, $stateParams, $http, $location, AuthenticationService, UserService ) ->

        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams

        $rootScope.apiBase = "http://localhost:3000"

        # $rootScope.state = $state
        # $rootScope.stateParams = $stateParams

        # $rootScope.globals = $cookieStore.get( "globals" ) or {}

        # if $rootScope.globals.currentUser
        #     AuthenticationService.SetExistingCredentials $rootScope.globals.currentUser
        #     UserService.init $rootScope.globals.currentUser.name

        # $rootScope.$on "$stateChangeStart", ( event, next, current ) ->
        #     unless next.name is "landingPage"
        #         unless $rootScope.globals.currentUser
        #             event.preventDefault()
        #             $state.go "landingPage"
]

# ***
# ## Config
# > contains routing stuff only (atm)
# >
# > see
# > [angular docs](http://docs.angularjs.org/guide/dev_guide.services.$location)
# > for $locationProvider details
app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    "$translateProvider"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider ) ->
        $locationProvider.html5Mode true

        #$urlRouterProvider.otherwise "/"

        $stateProvider
        .state "app",
            abstract: true
            url: "/{locale}"
            controller: 'AppCtrl'
            template: '<ui-view/>'
# /
        .state "app.landingPage",
            url: "/"
            templateUrl: "landing-page/landing-page.html"

# /import
        .state "app.import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

# /import
        .state "app.editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

# /penguins
        # .state "penguins",
        #     url: "/penguins"
        #     templateUrl: "penguins/penguins.html"
        #     controller: "PenguinCtrl"
        #     resolve:
        #         penguins: [
        #             "PenguinService"
        #             (PenguinService) ->
        #                 PenguinService.query()
        #         ]

# /penguins/new
        # .state "penguins.new",
        #     url: "/new"
        #     templateUrl: "penguins/penguins.new.html"
        #     controller: "PenguinCtrl"

# /penguins/:penguin
        # .state "penguins.detail",
        #     url: "/:penguin"
        #     templateUrl: "penguins/penguin.detail.html"
        #     controller: "PenguinCtrl"
        #     resolve:
        #         penguin: [
        #             "PenguinService"
        #             "$stateParams"
        #             (PenguinService, $stateParams) ->
        #                 PenguinService.get $stateParams.penguin
        #         ]

        # I18N
        $translateProvider
        .useStaticFilesLoader
            prefix: 'languages/'
            suffix: '.json'
        $translateProvider.preferredLanguage('de')

]
