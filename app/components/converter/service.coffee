# # Converter Service


"use strict"

app = angular.module "app.services"

# TODO: after extracting coordinates they have to be converted to decimal format

app.service 'ConverterService', [
    "$timeout"
    "ParserService"
    "HelperService"
    "ProgressOverlayService"
    ($timeout, Parser, Helper, ProgressOverlay) ->
        class Converter

            # @method convertSHP2GeoJSON
            # @public
            # @param {Buffer} buffer
            # @return {Promise}
            convertSHP2GeoJSON: (buffer) ->
                return shp(buffer)

            # @method convertCSV2Arrays
            # @public
            # @param {CSV} csv
            # @return {Array}
            convertCSV2Arrays: (csv) ->
                return Papa.parse(csv).data

            # converts a geoJSON object into a two dimensional array, which can be used in the data table.
            # @method convertGeoJSON2Arrays
            # @param {geoJSON} geoJSON
            # @return {array}
            convertGeoJSON2Arrays: (geoJSON) ->
                dataset = []

                geoJSON.features.forEach (feature) ->
                    if feature.geometry.type is "MultiPolygon"
                        feature.geometry.coordinates.forEach (polygon, index) ->
                            newRow = []

                            for property, value of feature.properties
                                newRow.push value

                            for property, value of feature.geometry
                                if property is "bbox"
                                    value.forEach (coordinate) ->
                                        newRow.push coordinate
                                else if property is "coordinates"
                                    newRow.push "Polygon " + (index + 1)
                                    polygon.forEach (pair) ->
                                        pair.forEach (coordinates) ->
                                            coordinates.forEach (coordinate) ->
                                                newRow.push coordinate
                                else
                                    newRow.push value

                            dataset.push newRow

                    else
                        newRow = []

                        for property, value of feature.properties
                            newRow.push value

                        for property, value of feature.geometry
                            if property is "bbox"
                                value.forEach (coordinate) ->
                                    newRow.push coordinate

                            else if property is "coordinates"
                                if feature.geometry.type is "Point"
                                    feature.geometry.coordinates.forEach (coordinate) ->
                                        newRow.push coordinate

                                else
                                    feature.geometry.coordinates.forEach (pair) ->
                                        pair.forEach (coordinates) ->
                                            coordinates.forEach (coordinate) ->
                                                newRow.push coordinate

                            else
                                newRow.push value

                        dataset.push newRow

                return dataset

            # adds multiple column headers with the same name and an incrementing counter.
            # @method addHeaderCols
            # @param {array} value
            # @param {array} array The header to add more headers with the same text.
            # @param {string} text The text to be added.
            # @param {integer} counter
            # @return {array}
            addHeaderCols: (value, array, text, counter) =>
                if Array.isArray value
                    value.forEach (element) =>
                        if Array.isArray element
                            array = @addHeaderCols(element, array, text, counter)
                            counter = counter + 2
                        else
                            array.push text + " " + counter.toString()
                            counter++

                return array

            # extracts the column headers for the table from a geoJSON object and returns them.
            # @method convertGeoJSON2ColHeaders
            # @param {geoJSON} geoJSON
            # @return {array}
            convertGeoJSON2ColHeaders: (geoJSON) ->
                colHeaders = []

                maxIndex = 0
                maxSize = 0

                # Finds the biggest multidimensional array.
                for property, value of geoJSON.features
                    currentSize = @sizeOfMultiArray value.geometry.coordinates
                    if currentSize > maxSize
                        maxSize = currentSize
                        maxIndex = property

                for property, value of geoJSON.features[maxIndex].properties
                    colHeaders.push property

                for property, value of geoJSON.features[maxIndex].geometry

                    if property is "bbox" or property is "coordinates"
                        colHeaders = @addHeaderCols(value, colHeaders, property, 0)

                    else
                        colHeaders.push property

                return colHeaders

            # Returns the size of a multidimensional array.
            # @method sizeOfMultiArray
            # @param {Array} array
            sizeOfMultiArray: (array) ->
                size = 0

                if Array.isArray array[0]
                    for property, value of array
                        size = size + @sizeOfMultiArray(value)
                    return size
                else
                    return array.length

            # @method convertArrays2GeoJSON
            # @public
            # @param {Array} dataset
            # @return {GeoJSON}
            convertArrays2GeoJSON: (dataset) ->
                dataset = Helper.trimDataset(dataset)

                geoJSON =
                    "type": "FeatureCollection"
                    "features": []

                indicesCoordinates = Parser.findCoordinatesColumns(dataset)

                dataset.forEach (row) ->
                    coordinates = []

                    # distinguish if coordinates are in the same column or in two different columns
                    if indicesCoordinates.hasOwnProperty("xy")
                        coordinates = Parser.extractCoordinatesOfOneCell row[indicesCoordinates["xy"]]
                    else if indicesCoordinates.hasOwnProperty("x") and indicesCoordinates.hasOwnProperty("y")
                        # TODO check for more formats than only decimal coordinates
                        latitude = parseFloat(row[indicesCoordinates["y"]])
                        longitude = parseFloat(row[indicesCoordinates["x"]])
                        # TODO check here also maybe with isCoordinate()
                        if(Helper.isNumber(latitude) and Helper.isNumber(longitude))
                            coordinates.push(latitude)
                            coordinates.push(longitude)
                    else
                        console.info "Keine Koordinaten gefunden."
                        return

                    unless coordinates.length
                        return

                    # JSON.parse(JSON.stringify(...)) deep copy the feature
                    # that the properties object is not always the same
                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                        "properties": {}
                    ))

                    if coordinates.length is 2
                        longitude = parseFloat(coordinates[1])
                        latitude = parseFloat(coordinates[0])
                        feature.geometry.coordinates = [longitude, latitude]
                        feature.geometry.type = "Point"
                    else
                        # TODO: 2 Arrays: Line, mehr: Polygon, lat - long für GeoJSON vertauschen
                        return

                    # All none coordinate cell should be filled into the properties of the feature
                    if indicesCoordinates.hasOwnProperty("xy")
                        row.forEach (cell, indexColumn) ->
                            if(indexColumn != indicesCoordinates["xy"])
                                feature.properties[indexColumn] = (cell)
                    else if indicesCoordinates.hasOwnProperty("x") and indicesCoordinates.hasOwnProperty("y")
                        row.forEach (cell, indexColumn) ->
                            if(indexColumn != indicesCoordinates["x"] and indexColumn != indicesCoordinates["y"])
                                feature.properties[indexColumn] = (cell)

                    geoJSON.features.push(feature)

                $timeout ->
                    ProgressOverlay.resetMessage()
                , 0
                return geoJSON

        new Converter
]
