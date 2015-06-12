###
DESCRIPTION
User should be allowed to drop a file everywhere, so the file drop directive is split into two parts.
Into the directive on which element it should start draggingZ and the directive on which element it should end
###

app = angular.module "app.directives"

app.directive 'ngFileDropEnd', ->
    link: ($scope, el) ->

#leave: cursor moves out of drop-zone
        el.bind "dragleave", (e) ->
            e.target.parentElement.style.display = "none"
            e.preventDefault()
            false
        .bind(this)

        #over: cursor currently moves over the drop-zone
        el.bind "dragover", (e) ->
            e.preventDefault()
            false

        #drop: file got dropped on the drop-zone
        el.bind "drop", (e) ->
            e.target.parentElement.style.display = "none"
            $scope.file = e.dataTransfer.files[0]
            $scope.getFile()
            e.preventDefault()
            false
