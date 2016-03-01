# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    "$timeout"
    "ShareService"
    "DataService"
    "ProgressService"
    "ngToast"
    "$log"
    "ConverterService"
    "$translate"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter, $translate) ->

        visualization = undefined
        chartData = undefined
        $scope.colHeadersSelection = Table.colHeadersSelection

        $translate([
            "DIAGRAMS.DIAGRAM_TYPE"
            "DIAGRAMS.SCATTER_PLOT"
            "DIAGRAMS.MAP"
            "DIAGRAMS.PARALLEL_COORDINATES"
            "DIAGRAMS.BAR_CHART"
            "DIAGRAMS.TIME_SERIES"
        ]).then (translations) ->
            $scope.selectedDiagramName = translations["DIAGRAMS.DIAGRAM_TYPE"]
            $scope.supportedDiagrams = [
                {
                    name: translations["DIAGRAMS.SCATTER_PLOT"]
                    type: "scatter"
                    imagePath: "/images/diagram-icons/scatter-plot.svg"
                }
                {
                    name: translations["DIAGRAMS.MAP"]
                    type: "map"
                    imagePath: "/images/diagram-icons/map.svg"
                }
                {
                    name: translations["DIAGRAMS.PARALLEL_COORDINATES"]
                    type: "parallel"
                }
                {
                    name: translations["DIAGRAMS.BAR_CHART"]
                    type: "bar"
                    imagePath: "/images/diagram-icons/bar-chart.svg"
                }
                {
                    name: translations["DIAGRAMS.TIME_SERIES"]
                    type: "timeseries"
                    imagePath: "/images/diagram-icons/line-chart.svg"
                }
            ]
            return $scope.supportedDiagrams
        .then (supportedDiagrams) ->
            for diagram in supportedDiagrams
                if diagram.type is $scope.diagramType
                    $scope.selectedDiagramName = diagram.name

        # create a new diagram based on the recommended diagram
        # @method createDiagram
        # @param {String} type
        createDiagram = (type) ->
            $log.info "Visualization controller createDiagram function called"
            switch type
                when "scatter"
                    chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                    new vidatio.ScatterPlot chartData
                when "map"
                    # TODO map dataset and merge parser & recommender
                    Map.setScope $scope

                    # Use the whole dataset because we want the other attributes inside the popups
                    geoJSON = Converter.convertArrays2GeoJSON trimmedDataset, Table.getColumnHeaders(), { x: xColumn, y: yColumn }
                    Map.setGeoJSON geoJSON
                when "parallel"
                    # Parallel coordinate chart needs the columns as rows and the values in x direction need to be first
                    transposedDataset = vidatio.helper.transposeDataset(trimmedDataset)
                    chartData = vidatio.helper.subsetWithXColumnFirst(transposedDataset, xColumn, yColumn)
                    chartData = vidatio.helper.transposeDataset(chartData)
                    new vidatio.ParallelCoordinates chartData
                when "bar"
                    # Bar chart need the columns as rows so we transpose
                    chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                    new vidatio.BarChart chartData
                when "timeseries"
                    # Currently default labels for the bars are used
                    chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                    new vidatio.TimeseriesChart chartData
                else
                    # TODO: show a default image here
                    $log.error "EdtiorCtrl recommend diagram failed, dataset isn't usable with vidatio"

        $scope.meta = Data.meta

        # @method setXAxisColumnSelection
        # @param {Number} id
        $scope.setXAxisColumnSelection = (id) ->
            $log.info "Visualization controller setXAxisColumnSelection called"
            $scope.xAxisCurrent = id
            $scope.changeAxisColumnSelection()

        # @method setYAxisColumnSelection
        # @param {Number} id
        $scope.setYAxisColumnSelection = (id) ->
            $log.info "Visualization controller setYAxisColumnSelection called"
            $scope.yAxisCurrent = id
            $scope.changeAxisColumnSelection()

        # @method changeAxisColumnSelection
        $scope.changeAxisColumnSelection = ->
            $log.info "Visualization controller changeAxisColumnSelection called"

            if $scope.diagramType? and $scope.diagramType isnt "map"
                # trimmedDataset: 2D dataset
                # value: row of the 2D dataset
                # value[$scope.xAxisCurrent]: cell of row
                # map: collects the cells of the selected columns
                chartData = [trimmedDataset.map((value, index) -> value[$scope.xAxisCurrent]),
                    trimmedDataset.map((value, index) -> value[$scope.yAxisCurrent])]
                visualization.updateDataset(chartData)

        dataset = Table.getDataset()
        trimmedDataset = vidatio.helper.trimDataset(dataset)
        subset = vidatio.helper.getSubset(trimmedDataset)

        switch Data.meta.fileType
            when "shp"
                $scope.diagramType = "map"
                Map.setScope $scope
            else
                { recommendedDiagram, xColumn, yColumn } = vidatio.recommender.run subset, Table.getColumnHeaders()
                $log.info "Recommender chose type: #{recommendedDiagram} with column #{xColumn} and #{yColumn}"

                $scope.diagramType = recommendedDiagram
                $scope.xAxisCurrent = String(xColumn)
                $scope.yAxisCurrent = String(yColumn)

                # trimmedDataset: 2D dataset
                # value: row of the 2D dataset
                # value[$scope.xAxisCurrent]: cell of row
                # map: collects the cells of the selected columns
                chartData = [trimmedDataset.map((value, index) -> value[$scope.xAxisCurrent]),
                    trimmedDataset.map((value, index) -> value[$scope.yAxisCurrent])]

                Table.setDiagramColumns xColumn, yColumn

                createDiagram(recommendedDiagram)

        $timeout ->
            Progress.setMessage ""

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "ShareCtrl shareVisualization called"
            $log.debug
                message: "ShareCtrl shareVisualization called"
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "ShareCtrl shareVisualization promise success called"
                $log.debug
                    message: "Share mapToImg success callback"
                    obj: obj

                Progress.setMessage ""

                if Data.meta.fileName == ""
                    fileName = vidatio.helper.dateToString(new Date())
                else
                    fileName = Data.meta.fileName

                Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"
            , (notify) ->
                Progress.setMessage notify

        $scope.selectDiagram = (name, type) ->
            $log.info "Visualization controller selectDiagram called"
            $log.debug
                name: name
                type: type

            $scope.selectedDiagramName = name
            createDiagram(type)
]
