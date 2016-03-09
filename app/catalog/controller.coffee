"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "$translate"
    "ngToast"
    "UserService"
    ($scope, CatalogFactory, $log, $translate, ngToast, User) ->

        $scope.filter =
            dates:
                from: undefined
                to: undefined
            category: ""
            showOwnVidatios: false

        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        $scope.user = User.user

        console.log "$scope.user", $scope.user

        $('#own-vidatios-checkbox').radiocheck()

        CatalogFactory.getCategories().query (response) ->
            $log.info "CatalogCtrl successfully queried categories"
            $scope.categories = response

        CatalogFactory.getDatasets().query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            for vidatio, index in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)

        , (error) ->
            $log.info "CatalogCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        $scope.setCategory = (category) ->
            vidatio.log.info "CatalogCtrl setCategory called"
            vidatio.log.debug
                category: category
            $scope.filter.category = category

        # $scope.toggleOwnVidatios = ->

        #     console.log "$scope.showOwnVidatios", $scope.showOwnVidatios
        #     $scope.showOwnVidatios = !$scope.showOwnVidatios
        #     console.log "$scope.showOwnVidatios", $scope.showOwnVidatios
        #     console.log "!$scope.showOwnVidatios", !$scope.showOwnVidatios

]
