"use strict"

app = angular.module "app.controllers"

app.controller "VidatioOverviewCtrl", [
    "$scope"
    "$translate"
    "ngToast"
    "$cookieStore"
    "ProgressService"
    "DataService"
    "DatasetFactory"
    "ErrorHandler"
    "$window"
    ($scope, $translate, ngToast, $cookieStore, Progress, Data, DatasetFactory, ErrorHandler, $window) ->
        $scope.$watch "vidatio", ->
            return unless $scope.vidatio
            globals = $cookieStore.get "globals"
            if globals?
                console.log $scope.vidatio.metaData
                $scope.authorized = globals.currentUser.id is $scope.vidatio.metaData.userId._id
            else
                $scope.authorized = false
        , true

        $scope.openInEditor = ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData $scope.vidatio

        $scope.deleteVidatio = ->
            return unless $window.confirm $translate.instant("DATASET_DELETE_CONFIRMATION")

            DatasetFactory.delete {id: $scope.vidatio._id}, (data) ->
                idx = $scope.$parent.vidatios.indexOf $scope.vidatio
                $scope.$parent.vidatios.splice idx, 1
                $translate("TOAST_MESSAGES.DATASET_DELETED")
                .then (translation) ->
                    ngToast.create
                        content: translation
            , (error) ->
                return ErrorHandler.format error

]
