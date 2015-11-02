"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    "$timeout"
    ($timeout) ->
        restrict: "E"
        templateUrl: "menu/menu.html"
        replace: true
        link: ($scope, $element) ->

            # Menu can have 3 different layouts so init in on every state change
            $scope.$on "$stateChangeSuccess", ->
                $timeout ->
                    $("#menu").jPushMenu()

            $scope.toggleMenu = ->
                $('#menu,body,.cbp-spmenu').removeClass "disabled active cbp-spmenu-open cbp-spmenu-push-toleft cbp-spmenu-push-toright menu-active"
                return true
]