# Converter Service
# ======================

"use strict"

app = angular.module "app.services"

app.factory 'ConverterService', [ ->
    class Converter
        convertSHP2GeoJSON: (buffer) ->
            shp(buffer).then (geoJSON) ->
                return geoJSON

        convertCSV2Arrays: (csv) ->
            # TODO: add here further splitting options
            # e.g. split with another separator

            dataset = []
            rows = csv.split('\n')
            rows.forEach (row, index) ->
                dataset.push rows[index].split(',')
            return dataset

        convertSHP2Arrays: (shp) ->
            return @convertSHP2GeoJSON(shp).then (geoJSON) ->
                dataset = []

                geoJSON.features.forEach (feature) ->

                    if feature.geometry.type == "MultiPolygon"
                        feature.geometry.coordinates.forEach (polygon, index) ->
                            newRow = []

                            for property, value of feature.properties
                                newRow.push value

                            for property, value of feature.geometry
                                if property == "bbox"
                                    value.forEach (coordinate) ->
                                        newRow.push coordinate
                                else if property == "coordinates"
                                    newRow.push "Polygon " + (index + 1)
                                    polygon.forEach (pair) ->
                                        console.log "pair", pair
                                        pair.forEach (coordinate) ->
                                            console.log "coordinate"
                                            newRow.push coordinate
                                else
                                    newRow.push value

                            dataset.push newRow

                    else
                        newRow = []

                        for property, value of feature.properties
                            newRow.push value

                        for property, value of feature.geometry
                            if property == "bbox"
                                value.forEach (coordinate) ->
                                    newRow.push coordinate

                            else if property == "coordinates"
                                if feature.geometry.type == "Point"
                                    console.log "is point"
                                    feature.geometry.coordinates.forEach (coordinate) ->
                                        newRow.push coordinate

                                else if feature.geometry.type == "MultiPolygon"
                                    console.log "is multipolygon"
                                    console.log feature.geometry.coordinates
                                    feature.geometry.coordinates.forEach (polygon) ->
                                        console.log "polygon", polygon
                                        polygon.forEach (pair) ->
                                            console.log "pair", pair
                                            pair.forEach (coordinate) ->
                                                console.log "coordinate"
                                                newRow.push coordinate

                                else 
                                    feature.geometry.coordinates.forEach (pair) ->
                                        pair.forEach (coordinate) ->
                                            newRow.push coordinate

                            else
                                newRow.push value

                        dataset.push newRow

                return dataset
        convertArrays2GeoJSON: (arrays) ->
            geoJSON =
                "type": "FeatureCollection"
                "features": []

            arrays.forEach (element) =>
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if @isCoordinate(lat, lng)
                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                    ))
                    feature.geometry.coordinates = [parseFloat(lng), parseFloat(lat)]
                    feature.geometry.type = "Point"
                    geoJSON.features.push(feature)
            return geoJSON

        isCoordinate: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

    new Converter
]
