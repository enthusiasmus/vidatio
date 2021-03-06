# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "$rootScope"
    "$translate"
    "DataService"
    "$log"
    "MapService"
    "TableService"
    "$timeout"
    "CategoriesFactory"
    "VisualizationService"
    "$stateParams"
    "ProgressService"
    "ngToast"
    "ErrorHandler"
    "$state"
    "$window"
    "$location"
    "TagsService"
    ($scope, $rootScope, $translate, Data, $log, Map, Table, $timeout, Categories, Visualization, $stateParams, Progress, ngToast, ErrorHandler, $state, $window, $location, Tags) ->
        setScopeData = ->
            $scope.hasData = Table.hasData()
            $scope.vidatio = Data.metaData

        if $stateParams.id and not Table.dataset[0].length
            promise = Data.requestVidatioViaID($stateParams.id)
            promise.then ->
                setScopeData()

        setScopeData()

        $scope.goToPreview = false
        $scope.visualization = Visualization.options
        $scope.vidatio.publish = if $scope.vidatio.publish? then $scope.vidatio.publish else true

        port = if $location.port() then ":" + $location.port() else ""
        $scope.host = $rootScope.hostUrl + port

        $scope.tags = Tags.getAndPreprocessTags()

        Categories.query (response) ->
            $scope.categories = response

        $timeout ->
            #to change color after user selection (impossible with css)
            $(".selection select").change -> $(this).addClass "selected"

            #plus-button for tags-input
            $(".add-tag").click -> $(".bootstrap-tagsinput input").focus()

            #flat-ui checkbox
            $("#publish").radiocheck()

        # copied from login controller, redundant?
        # To give the prepends tags of flat ui the correct focus style
        $(".input-group").on("focus", ".form-control", ->
            $(this).closest(".input-group, .form-group").addClass "focus"
        ).on "blur", ".form-control", ->
            $(this).closest(".input-group, .form-group").removeClass "focus"

        $timeout ->
            Visualization.create()

        $scope.saveDataset = ->
            if not Table.hasData()
                $translate('TOAST_MESSAGES.DATASET_IS_EMPTY')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
                return

            $translate("OVERLAY_MESSAGES.SAVE_DATASET").then (translation) ->
                Progress.setMessage translation

            if Visualization.options.type is "map"
                $targetElem = $("#map")
            else if Visualization.options.type is "parallel"
                $targetElem = $("#chart svg")
            else
                $targetElem = $("#d3plus")

            vidatio.visualization.visualizationToBase64String($targetElem)
            .then (obj) ->
                switch Data.metaData.fileType
                    when "csv"
                        dataset = Table.dataset.slice()
                        if Table.useColumnHeadersFromDataset
                            dataset.unshift Table.header
                    when "shp"
                        dataset = Map.getGeoJSON()

                Data.saveViaAPI dataset, $scope.vidatio, obj["png"], (errors, response) ->
                    Progress.resetMessage()

                    if errors?
                        ErrorHandler.format errors
                        return false

                    $scope.vidatio = response

                    $scope.link = $state.href("app.dataset", {id: response._id}, {absolute: true})

                    $translate('TOAST_MESSAGES.DATASET_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation

                    return $scope.goToPreview = !$scope.goToPreview

            .catch (error) ->
                $log.error error
                $translate(error.i18n).then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        $scope.downloadVisualization = (type) ->
            fileName = $scope.vidatio.name + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            Visualization.downloadAsImage fileName, type

        $scope.downloadCSV = ->
            Data.downloadCSV($scope.vidatio.name)

        # @method $scope.openPopup
        # @description open social-media popups with base url as parameter in a new centered popup
        $scope.openPopup = (url, title, w, h) ->
            dualScreenLeft = if $window.screenLeft isnt undefined then $window.screenLeft else screen.left
            dualScreenTop = if $window.screenTop isnt undefined then $window.screenTop else screen.top
            width = if $window.innerWidth then $window.innerWidth else if document.documentElement.clientWidth then document.documentElement.clientWidth else screen.width
            height = if $window.innerHeight then $window.innerHeight else if document.documentElement.clientHeight then document.documentElement.clientHeight else screen.height

            left = width / 2 - (w / 2) + dualScreenLeft
            top = height / 2 - (h / 2) + dualScreenTop
            url = "#{url}#{decodeURIComponent($scope.link)}"
            newWindow = $window.open(url, title, "scrollbars=yes, width=" + w + ", height=" + h + ", top=" + top + ", left=" + left)
            if $window.focus
                newWindow.focus()
]
