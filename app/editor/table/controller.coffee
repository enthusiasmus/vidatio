"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    "DataService"
    "MapService"
    "ConverterService"
    "$log"
    "VisualizationService"
    ($scope, Table, Share, Data, Map, Converter, $log, Visualization) ->
        $scope.dataset = Table.dataset
        $scope.data = Data

        # attention: one way data binding
        $scope.useColumnHeadersFromDataset = Table.useColumnHeadersFromDataset

        headerCheckbox = $('#column-headers-checkbox')
        if headerCheckbox?.radiocheck? then headerCheckbox.radiocheck()

        $scope.toggleHeader = ->
            clearFocusedAxisButtons()

            $log.info "TableCtrl changeUseOfHeader called"

            if $scope.data.metaData.fileType isnt "shp"
                if $scope.useColumnHeadersFromDataset
                    Table.takeHeaderFromDataset()
                else
                    Table.putHeaderToDataset()

            Visualization.create()

        #@method $scope.transpose
        #@description transpose the dataset including the header
        $scope.transpose = ->
            clearFocusedAxisButtons()

            $log.info "TableCtrl transpose called"

            if $scope.useColumnHeadersFromDataset then Table.putHeaderToDataset()
            Table.setDataset vidatio.helper.transposeDataset Table.getDataset()
            if $scope.useColumnHeadersFromDataset then Table.takeHeaderFromDataset()

        #@method $scope.download
        #@description downloads a csv
        $scope.download = ->
            clearFocusedAxisButtons()
            Data.downloadCSV($scope.data.name)

        #@method $scope.axisSelection
        #@description selects axis by clicking on the header and creates new visualization
        $scope.axisSelection = (axis) ->
            $header = $(".ht_clone_top th")
            $header.removeClass "selected"
            $header.unbind "click"

            if axis is "x"
                if $(".x-axis-button").hasClass "focused"
                    $(".x-axis-button").removeClass "focused"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.xColumn) + 1
                $(".y-axis-button").removeClass "focused"
                $(".x-axis-button").addClass "focused"
            else
                if $(".y-axis-button").hasClass "focused"
                    $(".y-axis-button").removeClass "focused"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.yColumn) + 1
                $(".x-axis-button").removeClass "focused"
                $(".y-axis-button").addClass "focused"

            $header.addClass "highlighted"

            $header.each (idx, element) ->
                if idx is currentColumn
                    $(element).addClass "selected"

                $(element).click (event) ->
                    if not $(element).find("span").hasClass "selected-x-y"
                        $header.find("span").removeClass "selected-x-y"

                        if axis is "x"
                            $scope.visualization.xColumn = $(element).context.cellIndex - 1
                            $header.find("span").removeClass "selected-x"
                            $(element).find("span").addClass "selected-x"

                            if $(element).find("span").hasClass "selected-y"
                                $(element).find("span").addClass "selected-x-y"

                        else
                            $scope.visualization.yColumn = $(element).context.cellIndex - 1
                            $header.find("span").removeClass "selected-y"
                            $(element).find("span").addClass "selected-y"

                            if $(element).find("span").hasClass "selected-x"
                                $(element).find("span").addClass "selected-x-y"

                        Visualization.create()

                    clearFocusedAxisButtons()
                    $header.removeClass "highlighted"
                    $header.removeClass "selected"
                    $header.unbind "click"

            return true

            vidatio.visualization.download fileName + ".csv", csvURL
        # remove focus-states from axis-buttons if other icons are clicked
        clearFocusedAxisButtons = ->
            $("[class*='-axis-button']").removeClass "focused"
]
