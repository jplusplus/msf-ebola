angular.module "msfEbola"
  .controller "MainCtrl", ($scope, main, days, centers) ->
    $scope.months = main.months
    # Progression of the draggable slider
    $scope.progress = 0
    # Last data relative to the current day
    $scope.day = null
    # Create a slot for every weeks
    $scope.weeks = {}
    # Count weeks
    weeksCount = 0
    # Extract week date from the first day of each week
    for data in days
      unless data.day % 7
        ++weeksCount
        # Number of new cases this week
        data.cases = 0
        # week.victims = new Array(bundles)
        for key, zone of data.regional_data
          # Count new cases for each zone
          if zone.weekly_new_cases?
            data.cases += 1*zone.weekly_new_cases
        # Cases are bundled by stack of 10 cases
        victims = Math.max 0, Math.round(data.cases/10)
        # Create an array of X empty rows
        data.victims = new Array victims
        # Save the date for this week
        $scope.weeks[data.timestamp] = data
    # Map's settings
    $scope.settings = main.settings
    # The given slot number must be smaller than the progress
    $scope.progressFilter = (index)-> (index+1)/weeksCount <= $scope.progress/100
    # Calculates the date for the current progress value
    $scope.progressDate = ->
      # Create a new date object
      start = new Date do main.start.getTime
      # Calculate the number of day spend
      daysCount = (weeksCount * 7) * $scope.progress/100
      # And add the days to the date
      start.setDate start.getDate() + daysCount
      # Then returns the new datte
      start
    # Get the width style of the given figure in propertion to the total
    $scope.figureStyle = (figure)->
      data = $scope.day.regional_data
      total = data.death_total + data.cases_total + data.recovered_msf_cumulative
      if total is 0
        width: Math.round(100/3) + "%"
      else
        width: Math.round(figure/total*100) + "%"
    # Update the day data
    $scope.$watch 'progress', ->
      $scope.today = $scope.progressDate()
      current = $scope.today.getTime() / 1000
      $scope.day = null
      for data in days
        break if 1*data.timestamp > current
        $scope.day = data
