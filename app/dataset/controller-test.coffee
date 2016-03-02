"use strict"

describe "Dataset Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Table =
                setDataset: (result) ->

            DatasetCtrl = $controller "DatasetCtrl",  {$scope: @scope, $rootScope: @rootScope, TableService: @Table}

    describe "on clicked createVidatio", ->
        it 'should redirect to editor-page and set the data from the current Vidatio using Table.setDataset', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.data = []

            spyOn(@Table, 'setDataset')
            @scope.createVidatio()
            expect(@Table.setDataset).toHaveBeenCalled()

    describe "on clicked getLink-button", ->
        it 'should show the Vidatio-link box including the link to the current Vidatio on click at link-button', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.toggleVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(true)

            @scope.toggleVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(false)

    describe "on clicked close-cross in link-box", ->
        it 'should hide the Vidatio-link box on click at the cross', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.hideVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(false)