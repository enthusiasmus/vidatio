"use strict"
app = angular.module "app.directives"

app.directive 'hot', [
    "$timeout"
    "$log"
    "DataService"
    "TableService"
    ($timeout, $log, Data, Table) ->
        restriction: "EA"
        template: '<div id="datatable"></div>'
        replace: true
        scope:
            dataset: '='
            activeViews: '='
            useColumnHeadersFromDataset: '='
        link: ($scope, $element) ->
            $log.info "HotDirective link called"

            hot = new Handsontable($element[0],
                data: $scope.dataset
                minCols: 26
                minRows: 26
                rowHeaders: true
                colHeaders: true
                currentColClassName: 'current-col'
                currentRowClassName: 'current-row'
                beforeChange: (change, source) ->
                    $log.info "HotDirective beforeChange called"
                    $log.debug
                        message: "HotDirective beforeChange called"
                        change: change
                        source: source

                    if !Data.validateInput(change[0][0], change[0][1], change[0][2], change[0][3])
                        change[0][3] = change[0][2]

                afterChange: (change, source) ->
                    $log.info "HotDirective afterChange called"
                    $log.debug
                        message: "HotDirective afterChange called"
                        change: change
                        source: source

                    if change and change[0][3] != change[0][2]
                        # TODO add commands for other chart types
                        # use a variable "recommendDiagramm" to choose the right update function

                        Data.updateMap(change[0][0], change[0][1], change[0][2], change[0][3])
                        # Needed for updating the map, else the markers are
                        # updating too late from angular refreshing cycle
                        $scope.$applyAsync()
                afterInit: ->

            )

            Table.setInstance hot
            Table.initAxisSelection()
            if Table.useColumnHeadersFromDataset
                Table.takeColumnHeadersFromDataset()

            # Render of table is even then called, when table
            # view is not active, refactoring possible
            $scope.$watch (->
                $scope.activeViews
            ), ( ->
                # Need to wait for digest cycle
                # apply and digest don't work
                $timeout(->
                    hot.render()
                , 25)
            ), true

            $scope.$watch (->
                $scope.dataset
            ), ( ->
                hot.render()
            ), true

            # Needed for correct displayed table
            Handsontable.Dom.addEvent window, 'resize', ->
                $log.info "HotDirective resize called"

                offset = Handsontable.Dom.offset $element[0]

                wrapperWidth = Handsontable.Dom.innerWidth $element.parent()[0]
                wrapperHeight = Handsontable.Dom.innerHeight $element.parent()[0]
                availableWidth = wrapperWidth - offset.left - offset.right
                availableHeight = wrapperHeight - offset.top - offset.bottom

                $element.parent()[0].style.width = availableWidth + 'px'
                $element.parent()[0].style.height = availableHeight + 'px'
                hot.render()
]
