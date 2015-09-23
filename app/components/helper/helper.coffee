"use strict"

app = angular.module "app.services"

app.service 'HelperService', [ ->
    class Helper
        constructor: ->
            @rowLimit = 100

        trimDataset: (dataset) ->
            tmp = []

            topRow = undefined
            leftCell = Infinity
            rightCell = -Infinity
            bottomRow = -Infinity

            dataset.forEach (row, indexRow) ->
                row.forEach (cell, indexCell) ->
                    if cell
                        if typeof topRow == 'undefined'
                            topRow = indexRow
                        if leftCell > indexCell
                            leftCell = indexCell
                        if bottomRow < indexRow
                            bottomRow = indexRow
                        if rightCell < indexCell
                            rightCell = indexCell

            dataset.forEach (row, indexRow) ->
                if indexRow < topRow or indexRow > bottomRow
                    return
                tmp.push row.slice(leftCell, rightCell + 1)

            return tmp

        ###
        #    @param {dataset} is used to create a matrix which has the amount of cells row and column wise as the dataset
        ###
        createMatrix: (dataset, initial) ->
            matrix = []
            dataset.forEach (row, indexRow) ->
                matrix.push([])
                row.forEach (column, indexColumn) ->
                    matrix[indexRow][indexColumn] = initial

            return matrix

        isNumber: (value) ->
            return typeof value == "number" && isFinite(value)


        cutDataset: (dataset) ->
            tmp = []
            for element, index in dataset
                if index == @rowLimit
                    break
                tmp.push element

            return tmp

    new Helper
]
