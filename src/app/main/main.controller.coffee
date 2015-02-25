angular.module "msfEbola"
  .controller "MainCtrl", ($scope, main) ->
    $scope.months = main.months
    # Progression of the draggable slider
    $scope.progress = 0
    # Stops the animation
    stopIncrDay = -> $interval.cancel(animation) if animation?
    # Create a slot for every weeks
    $scope.weeks = new Array(main.weeks)
    # Populate week's slot with fake data
    for week, i in $scope.weeks
      victims = ~~(50 * Math.random())
      $scope.weeks[i] = new Array(victims)
    # Map's settings
    $scope.settings = main.settings
    # The given slot number must be smaller than the progress
    $scope.progressFilter = (index)-> (index+1)/main.weeks <= $scope.progress/100
    # Calculates the date for the current progress value
    $scope.progressDate = ->
      # Create a new date object
      start = new Date do main.start.getTime
      # Calculate the number of day spend
      days = (main.weeks * 7) * $scope.progress/100
      # And add the days to the date
      start.setDate start.getDate() + days
      # Then returns the new datte
      start
