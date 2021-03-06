"use strict"

app = angular.module "app.factories"

app.factory 'UserFactory', [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/users/:id"
]

app.factory 'UserDatasetsFactory', [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/users/:id/datasets", { "limit": @limit }, { datasetsLimit: { "method": "GET", "params": { "limit": @limit }, isArray: true } }
]

app.factory 'UserAuthFactory', [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/auth"
]

app.factory 'UserUniquenessFactory', [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/users/check", null,
            check:
                method: "GET"
]
