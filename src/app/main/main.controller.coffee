angular.module "msfEbola"
  .controller "MainCtrl", ($scope, main) ->
    # Create 52 slots for each week
    $scope.weeks = new Array(main.weeks)
    # Populate week's slot with fake data
    for week, i in $scope.weeks
      victims = ~~(50 * Math.random())
      $scope.weeks[i] = new Array(victims)
    # Map's settings
    $scope.settings = main.settings
    # Progression of the draggable slider
    $scope.progress = 20/main.weeks*100
    # The given slot number must be smaller than the progress
    $scope.progressFilter = (index)-> (index+1)/main.weeks <= $scope.progress/100
