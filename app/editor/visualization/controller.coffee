# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    "ParserService"
    'leafletData'
    "$timeout"
    ($scope, Table, Map, Parser, leafletData, $timeout) ->


        SVGPath = '<svg version="1.0" id="Ebene_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                 viewBox="0 0 128.282 45.961" style="enable-background:new 0 0 128.282 45.961;" xml:space="preserve">
            <g>
                <path style="fill:#12DDC8;" d="M25.496,3.169C23.453,1.125,20.736,0,17.846,0s-5.607,1.126-7.651,3.169
                    c-4.219,4.219-4.219,11.083,0,15.302c3.844,3.844,6.369,6.371,7.649,7.652l7.652-7.652C29.715,14.252,29.715,7.387,25.496,3.169z"
                    />
                <g>
                    <path d="M68.688,15.873c-1.06,0-1.953,0.893-1.953,1.953c0,1.06,0.893,1.953,1.982,1.953c1.06,0,1.953-0.893,1.953-1.953
                        C70.669,16.766,69.776,15.873,68.688,15.873z"/>
                    <path d="M61.208,22.068l-2.54,7.813l-0.977,3.795l-1.032-3.795l-2.511-7.813h-3.153l5.135,15.069h3.125l4.359-12.793l3.651,0.012
                        v12.781h2.54c0.223,0,0.418-0.223,0.418-0.446V22.068H61.208z"/>
                    <path d="M81.639,19.613c0,0,0,1.674,0.112,3.153c-0.949-0.419-2.205-0.921-3.516-0.921c-3.265,0-5.413,2.511-5.413,5.637v4.269
                        c0,3.07,2.149,5.609,5.413,5.609c1.367,0,2.679-0.614,3.739-1.116l0.14,0.893h2.484V16.264h-2.958V19.613z M81.639,33.928
                        c-0.753,0.363-2.121,0.698-3.153,0.698c-1.786,0-2.707-1.284-2.707-3.209v-3.544c0-1.953,0.837-3.293,2.707-3.293
                        c1.116,0,2.344,0.363,3.153,0.642V33.928z"/>
                    <path d="M92.554,21.845c-1.73,0-3.181,0.335-4.744,0.837l0.698,2.567c1.06-0.335,2.791-0.669,4.046-0.669
                        c1.73,0,2.372,0.921,2.372,2.986v0.781h-2.679c-2.735,0-5.33,1.144-5.33,4.325c0,2.958,2.149,4.688,4.939,4.688
                        c1.228,0,2.511-0.586,3.404-1.144l0.14,0.921h2.483v-9.962C97.884,23.994,96.014,21.845,92.554,21.845z M94.926,34.318
                        c-0.809,0.307-1.73,0.586-2.986,0.586c-1.284,0-2.065-1.06-2.065-2.316c0-1.06,0.837-2.009,2.567-2.009h2.484V34.318z"/>
                    <path d="M111.862,15.873c-1.06,0-1.953,0.893-1.953,1.953c0,1.06,0.893,1.953,1.981,1.953c1.06,0,1.953-0.893,1.953-1.953
                        C113.843,16.766,112.95,15.873,111.862,15.873z"/>
                    <path d="M104.11,22.068v-4.297h-2.344l-0.447,4.297h-2.204v2.288h2.037v8.651c0,2.121,1.395,4.353,4.549,4.353
                        c0.502,0,1.535-0.167,2.288-0.391l-0.335-2.623c-0.698,0.139-1.591,0.279-1.953,0.279c-1.172,0-1.591-0.67-1.591-1.925v-8.344
                        h6.329v12.781h2.539c0.223,0,0.419-0.223,0.419-0.446V22.068H104.11z"/>
                    <path d="M122.171,21.845c-3.711,0-6.027,2.735-6.027,6.111v3.32c0,3.377,2.344,6.083,6.083,6.083c3.739,0,6.055-2.707,6.055-6.083
                        v-3.32C128.282,24.58,125.938,21.845,122.171,21.845z M125.324,31.054c0,1.981-0.921,3.572-3.097,3.572
                        c-2.205,0-3.125-1.591-3.125-3.572v-2.846c0-2.009,0.921-3.628,3.07-3.628c2.233,0,3.153,1.618,3.153,3.628V31.054z"/>
                </g>
                <g>
                    <path style="fill:#FF5346;" d="M30.598,15.637c-0.662,1.76-1.696,3.411-3.11,4.825l-9.646,9.646l-0.996-0.998
                        c0,0-2.795-2.801-8.643-8.648c-1.414-1.414-2.448-3.065-3.11-4.825C1.944,18.855,0,23.257,0,28.116
                        c0,9.856,7.99,17.846,17.846,17.846c9.856,0,17.846-7.99,17.846-17.846C35.691,23.257,33.747,18.855,30.598,15.637z"/>
                </g>
            </g>
            </svg>
            '
        # vectorIcon = L.VectorMarkers.icon
        #     icon: ''
        #     iconSize: [128.282, 45.961]
        #     prefix: ''
        #     markerColor: '#089988'
        #     spin: true
        #     SVGPath: SVGPath

        icon =
            iconUrl: '../images/marker-small.png'
            iconSize: [25, 30]
            iconAnchor: [12.5, 30]
            popupAnchor: [0, -30]

        leafletData.getMap("map").then (map) ->
            Map.map = map
            # Timeout is needed to wait for the view to finish render
            $timeout ->
                Map.init()

        $scope.geojson =
            data: Map.geoJSON
            style: (feature) ->
                {}
            pointToLayer: (feature, latlng) ->
                new L.marker(latlng, icon: L.icon(icon))

            onEachFeature: (feature, layer) ->
                # So every markers gets a popup
                html = ""
                isFirstAttribute = true

                for property of feature.properties
                    value = feature.properties[property]

                    if isFirstAttribute
                        html += "<b>"

                    if Parser.isEmailAddress(value)
                        html += "<a href='mailto:" + value + "' target='_blank'>" + value + "</a><br>"
                    else if Parser.isPhoneNumber(value)
                        html += "<a href='tel:" + value + "' target='_blank'>" + value + "</a><br>"
                    else if Parser.isURL(value)
                        html += "<a href='" + value + "' target='_blank'>" + value + "</a><br>"
                    else if value
                        html += value + "<br>"

                    if isFirstAttribute
                        html += "</b>"
                        isFirstAttribute = false

                unless html
                    html = "Keine Informationen vorhanden"

                layer.bindPopup(html)
]
