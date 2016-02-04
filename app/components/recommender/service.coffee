"use strict"

class window.vidatio.Recommender
    constructor: ->
        vidatio.log.info "Recommender constructor called"
        @recommendedDiagram = null
        @types = ["coordinate", "date", "nominal", "numeric", "unknown"]
        @thresholdPC = 500
        @thresholdBar = 10

    # @method getSchema
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} schema, types of the columns
    getSchema: (dataset) ->
        vidatio.log.info "Recommender getSchema called"
        vidatio.log.debug JSON.stringify
            dataset: dataset

        schema = []

        dataset.forEach (column) =>
            if vidatio.helper.isCoordinateColumn column
                schema.push @types[0]
            else if vidatio.helper.isDateColumn column
                schema.push @types[1]
            else if vidatio.helper.isNominalColumn column
                schema.push @types[2]
            else if vidatio.helper.isNumericColumn column
                schema.push @types[3]
            else
                schema.push @types[4]

        return schema

    # @method getVariances
    # @public
    # @param {Array} dataset with rows and columns
    # @return {Array} variances of the values of each column
    getVariances: (dataset) ->
        vidatio.log.info "Recommender getVariances called"
        vidatio.log.debug JSON.stringify
            dataset: dataset

        variances = []

        dataset.forEach (column, idx, array) ->
            differentValues = {}
            column.forEach (cell, idx, array) ->
                differentValues[cell] = true

            count = 0
            for own key of differentValues
                count++

            variances.push count / column.length

        return variances

    # @method run
    # @public
    # @param {Array} dataset
    # @return {recommendDiagram, xColumn, yColumn} the type of the recommend diagram,
    #   the index of the column for the x value,
    #   the index of the column for the y value
    # OR {error} Message with occurred error
    run: (subset = [], dataset = subset) ->
        vidatio.log.info "Recommender getRecommendedDiagram called"
        vidatio.log.debug
            subset: subset
            dataset: dataset

        if subset.length < 1 or subset[0].length < 2
            message = "Dataset have not enough dimensions!"
            return { error: message }

        xIndex = null
        yIndex = null
        @recommendedDiagram = null

        xVariance = null
        yVariance = null

        transposedDataset = vidatio.helper.transposeDataset subset

        schema = @getSchema(transposedDataset)
        variances = @getVariances(transposedDataset)

        for variance, index in variances
            if variance > xVariance

                if xIndex?
                    yIndex = xIndex
                    yVariance = xVariance

                xIndex = index
                xVariance = variance

            else if variance > yVariance
                yIndex = index
                yVariance = variance

        type = schema[xIndex] + " " + schema[yIndex]

        nominalIdx = xIndex if schema[xIndex] is "nominal"
        nominalIdx = yIndex if schema[yIndex] is "nominal"

        uniqueNominals = {}
        for row in dataset
            if row[nominalIdx] in uniqueNominals
                continue

            uniqueNominals[row[nominalIdx]] = true

            numberOfNominals = Object.keys(uniqueNominals).length
            if numberOfNominals > @thresholdBar
                break

        switch type

            when "numeric numeric", "nominal nominal"
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else
                    @recommendedDiagram = "scatter"

            when "nominal numeric"
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else if numberOfNominals > @thresholdBar
                    @recommendedDiagram = "scatter"
                else
                    @recommendedDiagram = "bar"

            when "numeric nominal"
                if dataset.length > @thresholdPC
                    @recommendedDiagram = "parallel"
                else if numberOfNominals > @thresholdBar
                    @recommendedDiagram = "scatter"
                else
                    @recommendedDiagram = "bar"

                tmp = xIndex
                xIndex = yIndex
                yIndex = tmp

            when "coordinate coordinate"
                @recommendedDiagram = "map"

            when "date numeric"
                @recommendedDiagram = "line"

            when "numeric date"
                @recommendedDiagram = "line"
                tmp = xIndex
                xIndex = yIndex
                yIndex = tmp

            else
                if (type.indexOf "unknown" isnt -1) and (dataset.length > @thresholdPC)
                    @recommendedDiagram = "parallel"
                else
                    @recommendedDiagram = "scatter"


        return {
        recommendedDiagram: @recommendedDiagram
        xColumn: xIndex
        yColumn: yIndex
        }
