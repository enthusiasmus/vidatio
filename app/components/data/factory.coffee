"use strict"

app = angular.module "app.factories"

app.factory "DatasetFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/datasets/:id"
]

app.factory "DatasetsFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + '/datasets/', { 'limit': @limit }, datasetsLimit:
            'method': 'GET'
            'params':
                'limit': @limit
            isArray: true
]
