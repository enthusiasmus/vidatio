# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    ($scope) ->
        $scope.tab = $scope.$parent.tab
]
