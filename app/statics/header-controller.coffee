# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "MapService"
    "DataService"
    "$log"
    ($scope, $rootScope, $timeout, Map, Data, $log) ->
        # The three bool values represent the three tabs in the header
        # @property activeViews
        # @type {Array}
        $rootScope.activeViews = [true, true]

        # Invert the value of the clicked tab to hide or show views in the editor
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 1 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $log.info "HeaderCtrl tabClicked called"
            $log.debug
                message: "HeaderCtrl tabClicked called"
                tabIndex: tabIndex

            $rootScope.activeViews[tabIndex] = !$rootScope.activeViews[tabIndex]

            # REFACTOR Needed to wait for leaflet directive to render
            $timeout ->
                Map.resizeMap()

        $scope.saveDataset = ->
            geoJSON = Map.getGeoJSON()
            userId = $rootScope.globals.currentUser.id
            Data.saveViaAPI geoJSON, userId

        $scope.hideLink = ->
            $rootScope.showLink = false

        $scope.copyLink = ->
            $log.info "HeaderCtrl copyLink called"
            link = document.querySelector '#link'
            range = document.createRange()
            range.selectNode link
            window.getSelection().addRange(range)

            try
                successful = document.execCommand 'copy'
                $log.debug
                    message: "HeaderCtrl copyLink copy link to clipboard"
                    successful: successful
            catch err
                $log.info "Link could not be copied"
                $log.error
                    error: error

            window.getSelection().removeAllRanges()
]
