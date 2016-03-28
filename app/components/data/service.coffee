"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    "ConverterService"
    "VisualizationService"
    "$rootScope"
    "ngToast"
    "$translate"
    "$log"
    "DatasetFactory"
    "$location"
    "$state"
    (Map, Table, Converter, Visualization, $rootScope, ngToast, $translate, $log, DatasetFactory, $location, $state) ->
        class Data
            constructor: ->
                @name = ""
                @meta =
                    "fileType": ""

            updateMap: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                Map.updateGeoJSONWithSHP(row, column, oldData, newData, key)

            validateInput: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

            # TODO: Name has to be set by the user

            # Sends the dataset to the API, which saves it in the database.
            # @method saveViaAPI
            # @param {Object} dataset
            # @param {String} name
            saveViaAPI: (dataset) ->
                DatasetFactory.save
                    name: @name
                    data: dataset
                    metaData:
                        fileType: @meta.fileType
                    options:
                        type: Visualization.options.type
                        xColumn: Visualization.options.xColumn
                        yColumn: Visualization.options.yColumn
                        color: Visualization.options.color
                        useColumnHeadersFromDataset: Table.useColumnHeadersFromDataset

                , (response) ->
                    $log.info("Dataset successfully saved")
                    $log.debug
                        response: response

                    $translate('TOAST_MESSAGES.DATASET_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation

                    link = $state.href("app.dataset", {id: response._id}, {absolute: true})
                    $rootScope.link = link
                    $rootScope.showLink = true
                , (error) ->
                    $log.error("Dataset couldn't be saved")
                    $log.debug
                        error: error

                    $translate('TOAST_MESSAGES.DATASET_NOT_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

            # @method createVidatio
            # @description from existing dataset
            # @param {Object} data
            createVidatio: (data) ->
                if @meta["fileType"] is "shp"
                    dataset = Converter.convertGeoJSON2Arrays data.data
                    Table.setDataset dataset
                    Table.useColumnHeadersFromDataset = true
                    Map.setGeoJSON data.data
                else
                    if data.options?
                        # Each value has to be assigned individually, otherwise all options get overwritten.
                        if data.options.type?
                            Visualization.options["type"] = data.options.type
                            $translate(Visualization.options.translationKeys[data.options.type]).then (translation) ->
                                Visualization.options["selectedDiagramName"] = translation
                        else
                            Visualization.options["type"] = false
                            Visualization.options["selectedDiagramName"] = false

                        Visualization.options["xColumn"] = if data.options.xColumn? then data.options.xColumn else null
                        Visualization.options["yColumn"] = if data.options.yColumn? then data.options.yColumn else null
                        Visualization.options["color"] = if data.options.color? then data.options.color else "#11DDC6"

                        if data.options.useColumnHeadersFromDataset?
                            Table.useColumnHeadersFromDataset = if data.options.useColumnHeadersFromDataset? then data.options.useColumnHeadersFromDataset else false

                            if Table.useColumnHeadersFromDataset
                                Table.setHeader data.data.shift()

                    Table.setDataset data.data

        new Data
]
