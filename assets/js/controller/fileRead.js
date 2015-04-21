angular.module('vidatio').controller('FileReadCtrl', function ($scope, $http, FileReader) {
  $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";
  $scope.progress = 0;

  // Read via link
  $scope.load = function () {
    var url = $scope.link;
    $http.get("/api", {
      params: {
        url: url
      }
    })
      .success(function (data) {
        $scope.content = data;
      });
  }

  // Read via Browsing and Drag-and-Drop
  $scope.getFile = function () {
    $scope.progress = 0;
    FileReader.readAsDataUrl($scope.file, $scope)
      .then(function (result) {
        $scope.content = result;
      });
  };

  $scope.$on("fileProgress", function (e, progress) {
    $scope.progress = progress.loaded / progress.total;
  });

  // Data table
  $scope.colHeaders = true;
  $scope.db = {};
  $scope.db.items = [
    {
      hours: 4
    },
    {
      hours: 8
    }
  ];

  $scope.db.dynamicColumns = [{
    data: 'hours',
    title: 'Hours worked per day'
  }];
});