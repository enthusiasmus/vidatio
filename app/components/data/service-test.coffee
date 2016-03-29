"use strict"

describe "Service Data", ->

    beforeEach ->
        module "app"

        inject (DataService, ConverterService, TableService, MapService, $rootScope, $q, $injector, VisualizationService) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()

            @Data = DataService
            @Converter = ConverterService
            @Converter.convertGeoJSON2Arrays = ->
            @Visualization = VisualizationService

            @Map = MapService
            @Map.init @scope
            @Map.setGeoJSON = ->

            @Table = TableService
            @Table.getInstance = ->
            @Table.instanceTable =
                getColHeader: ->
                    return [0,1,2,3,4,5,5,6,7]
                updateSettings: ->
                render: ->

            spyOn(@Converter, "convertArrays2GeoJSON")
            spyOn(@Map, "setGeoJSON")
            spyOn(@Map, "updateGeoJSONWithSHP")
            spyOn(@Table, "setDataset")
            spyOn(@Table, "setHeader")

    afterEach ->
        @Table.setDataset.calls.reset()
        @Table.setHeader.calls.reset()
        @Map.setGeoJSON.calls.reset()
        @Map.updateGeoJSONWithSHP.calls.reset()
        @Converter.convertArrays2GeoJSON.calls.reset()

    it "should be defined and included", ->
        expect(@Data).toBeDefined()
        expect(@injector.has("DataService"))

    it "should have a meta object", ->
        expect(@Data.metaData).toBeDefined()

    describe "should update Table and Map", ->
        it "with file type csv", ->
            @Data.metaData.fileType = "csv"
            @Data.updateMap 0, 0, "oldData", "newData"

            expect(@Converter.convertArrays2GeoJSON).not.toHaveBeenCalled()
            expect(@Map.setGeoJSON).not.toHaveBeenCalled()

        it "with file type shp", ->
            @Data.metaData.fileType = "shp"

            @Data.updateMap(0, 0, "oldData", "newData")
            expect(@Map.updateGeoJSONWithSHP).toHaveBeenCalled()

    describe "should create new Vidatio", ->
        data =
                data:
                    [
                        [1, 2, 3],
                        ["one", "two", "three"]
                    ]
                visualizationOptions:
                    type: "bar"
                    xColumn: 2
                    yColumn: 3
                    color: "#FF00FF"
                    useColumnHeadersFromDataset: true

        it "from shp data", ->
            @Data.metaData.fileType = "shp"
            @Data.useSavedData data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Map.setGeoJSON).toHaveBeenCalled()
            expect(@Table.useColumnHeadersFromDataset).toEqual(true)

        it "and set visualization options", ->
            visualizationOptions =
                type: "bar"
                xColumn: 2
                yColumn: 3
                color: "#FF00FF"
            @Data.useSavedData data
            expect(@Visualization.options).toEqual(jasmine.objectContaining(visualizationOptions))
            expect(@Table.useColumnHeadersFromDataset).toEqual(data.visualizationOptions.useColumnHeadersFromDataset)

        it "from csv data with user header", ->
            @Data.metaData.fileType = "csv"
            @Data.useSavedData data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setHeader).toHaveBeenCalled()

        it "from csv data without user header", ->
            data.visualizationOptions.useColumnHeadersFromDataset = false
            @Data.metaData.fileType = "csv"
            @Data.useSavedData data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setHeader).not.toHaveBeenCalled()



