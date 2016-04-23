"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$rootScope"
    "$scope"
    "ProgressService"
    "DataService"
    "$translate"
    "ngToast"
    "$stateParams"
    "$state"
    "DatasetFactory"
    "CategoriesFactory"
    "TagsService"
    "$log"
    "$timeout"
    ($rootScope, $scope, Progress, Data, $translate, ngToast, $stateParams, $state, Datasets, Categories, Tags, $log, $timeout) ->
        $timeout ->
            $("#search-title").on "focus", ->
                $("#search-filter").addClass "active"
            .on "blur", ->
                $("#search-filter").removeClass "active"

        angular.element('#my-vidatio-checkbox').radiocheck()
        stateParams = {}
        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')
        $scope.tags = Tags.getAndPreprocessTags()

        # @description Filter vidatios according to the GET parameters of the $stateParams
        $scope.filter =
            dates:
                from: if $stateParams.from then moment($stateParams.from, "DD-MM-YYYY") else ""
                to: if $stateParams.to then moment($stateParams.to, "DD-MM-YYYY") else ""
            category: if $stateParams.category then $stateParams.category else ""
            tags: if $stateParams.tags then $stateParams.tags.split("|") else ""
            name: if $stateParams.name then $stateParams.name else ""
            showMyVidatios: if $stateParams.myvidatios then if $stateParams.myvidatios is "true" then true else false

        stateParams = {}
        $scope.maxDate = moment.tz('CET')

        $scope.tags = Tags.getAndPreprocessTags()

        Categories.query (response) ->
            $scope.categories = response
        , (error) ->
            $translate('TOAST_MESSAGES.CATEGORIES_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        ###
        Datasets.query (response) ->
            $scope.vidatios = response

            for vidatio, index in $scope.vidatios
                vidatio.title = vidatio.metaData.name
                vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)
        , (error) ->
            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"
        ###

        $scope.vidatiosURL = $rootScope.apiBase + $rootScope.apiVersion + "/datasets/"
        $scope.vidatiosParameters =
            "limit": 4

        # the values of the datepicker need to be watched, because the ng-change directive never executes a function
        $scope.$watch "filter.dates.from", ->
            $scope.setStateParams()

        $scope.$watch "filter.dates.to", ->
            $scope.setStateParams()

        # @method setCategory
        # @description Set new category and update URL by setting new stateParams
        # @param {String} category
        $scope.setCategory = (category) ->
            $scope.filter.category = category
            $scope.setStateParams()

        # @method setStateParams
        # @description Determine which filters are active and send user to the same state with new $stateParams
        $scope.setStateParams = ->
            stateParams.myvidatios = if $scope.filter.showMyVidatios then $scope.filter.showMyVidatios else ""
            stateParams.category = if $scope.filter.category then $scope.filter.category else ""
            stateParams.tags = if $scope.filter.tags then $scope.filter.tags.join("|") else ""
            stateParams.from = if $scope.filter.dates.from then $scope.filter.dates.from.format("DD-MM-YYYY") else ""
            stateParams.to = if $scope.filter.dates.to then $scope.filter.dates.to.format("DD-MM-YYYY") else ""
            stateParams.name = if $scope.filter.name then $scope.filter.name else ""
            $scope.changeURL()

        # @method reset
        # @description Iterate over all filters in the filter object (and subsequent objects) and reset them
        #               by using an empty String
        $scope.reset = ->
            for attr of $scope.filter
                if $scope.filter[attr]?.constructor is Object
                    for childAttr of $scope.filter[attr]
                        $scope.filter[attr][childAttr] = ""
                else
                    $scope.filter[attr] = ""

            for attr of stateParams
                stateParams[attr] = ""

            $scope.changeURL()

        $scope.changeURL = ->
            $state.go $state.current, stateParams,
                notify: false
                reload: $state.current

]
