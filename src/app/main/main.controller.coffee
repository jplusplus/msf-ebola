angular.module "msfEbola"
  .controller "MainCtrl", ($scope, main) ->
    # Progression of the draggable slider
    $scope.progress = 0
    # Stops the animation
    stopIncrDay = -> $interval.cancel(animation) if animation?
    # Create 52 slots for each week
    $scope.weeks = new Array(main.weeks)
    # Populate week's slot with fake data
    for week, i in $scope.weeks
      victims = ~~(50 * Math.random())
      $scope.weeks[i] = new Array(victims)
    # Map's settings
    $scope.settings = main.settings
    # The given slot number must be smaller than the progress
    $scope.progressFilter = (index)-> (index+1)/main.weeks <= $scope.progress/100
