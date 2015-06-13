describe('Directive', function() {
  describe('ngFileSelect', function() {
    var scope, element;

    //mock Application to allow us to inject our own dependencies
    beforeEach(module('vidatio'));

    //mock the controller for the same reason and include $rootScope and $controller
    beforeEach(inject(function($rootScope, $controller, $compile){
      //create an empty scope
      scope = $rootScope.$new();

      //declare the controller and inject our empty scope
      $controller('FileReadCtrl', {$scope: scope});

      //combine template and scope
      element = $compile('<input type="file" ng-file-select="onFileSelect($files)">')(scope);

      //mock the function scope.getFile
      spyOn(scope, 'getFile').and.callFake(function(){});
    }));

    it("should create file reader", function() {
      var div = element[0];
      div.dispatchEvent(new CustomEvent('change'));
      expect(scope.getFile).toHaveBeenCalled();
    });
  });
});
