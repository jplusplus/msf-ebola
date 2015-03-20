angular.module "msfEbola"
  .controller "MainCtrl", ($scope, $rootScope, $compile, $stateParams, $timeout, leafletData, main, days, aggregation, centers, highlights) ->
    # Used to create a center marker
    createCenter = (center)->
      # A day must be selected
      return unless $scope.day? and $scope.day.centers[center.name]?
      # Get the today's data
      if center.type is 'support'
        center.icon = main.iconSupport
      else
        centerData = $scope.day.centers[center.name]
        # Count by types
        staff = Math.ceil(centerData.staff_count / 5)
        admitted = Math.ceil(centerData.weekly_new_admissions_rolling_avg / 5)
        # Create the icon using a template to visualize data
        center.icon = angular.extend angular.copy(main.iconCte),
          # Generate the content of this icon
          html: main.iconCte.template
            open: "" + centerData.is_open
            name: center.name
            staff: Array(staff + 1).join '<i class="fa fa-male"></i>'
            admitted: Array(admitted + 1).join '<i class="fa fa-male"></i>'
      center
    # Open a center's popup when clicking on its marker
    openCenter = (ev, marker)->
      # Stop openning until animation is over
      return if $scope.isAnimating
      # Get the controller map
      leafletData.getMap().then (map)->
        # Retreive the center for this marker
        center = centers[ marker.markerName ]
        # Popup position
        latLng = L.latLng(center.lat, center.lng)
        # Create the new popup
        centerPopup = L.popup().setLatLng(latLng).openOn(map)
        # Create a new scope for this popup
        scope = $scope.$new no
        angular.extend scope, center: center
        # Watch change
        scope.$watch 'today', ->
          # Cumulate data
          angular.extend scope.center, $scope.day.centers[center.name]
        # Get popup node
        content = angular.element centerPopup._contentNode
        content.html main.centerPopup
        # Compile template with the new scope
        $compile(content)(scope)
    # Animating by default
    $scope.isAnimating = yes
    # Every highlights must be available into the scope
    $scope.highlights = highlights
    # Months in human language
    $scope.months = main.months
    # Progression of the draggable slider
    $scope.progress = 0
    # Last data relative to the current day
    $scope.day = null
    # Create a slot for every weeks
    $scope.weeks = aggregation.weeks
    # Get weeks count
    $scope.weeksCount = aggregation.weeksCount
    # Create month ticks
    $scope.monthTicks = []
    # Find date bounds
    start = new Date(aggregation.start)
    end   = new Date(aggregation.end)
    delta = aggregation.end - aggregation.start
    # Iterate over years
    for year in [ start.getFullYear() .. end.getFullYear() ]
      # Iterate over months
      for month in [ 0 .. 11 ]
        # No before the starting month
        if year is start.getFullYear() and month >= start.getMonth() or
        # No after the ending month
        year is end.getFullYear() and month <= end.getMonth() or
        # No a bound years
        year isnt start.getFullYear() and year isnt end.getFullYear()
          # Create a date for this month
          date = new Date year, month + 1
          # Add the month position
          $scope.monthTicks.push((date.getTime() - start.getTime()) / delta)
    # Map's settings
    $scope.settings = main.settings
    # The given slot number must be smaller than the progress
    $scope.progressFilter = (index)-> (index+1)/aggregation.weeksCount <= $scope.progress/100
    # The given highlight is visible only for a moment
    $scope.highlightFilter = (highlight)->
      highlight.date_start <= $scope.today.getTime() and
      # The date end is always one day after the begining
      highlight.date_start + (24*60*60*1000) >= $scope.today.getTime() and
      # Highlights appear only during the animation
      $scope.isAnimating
    # True if an highlight is currently visible
    $scope.lastHighlight = -> _.find highlights, $scope.highlightFilter
    # Calculates the date for the current progress value
    $scope.progressDate = ->
      # Create a new date object
      start = new Date do main.start.getTime
      # Calculate the number of day spend
      daysCount = (aggregation.weeksCount * 7) * $scope.progress/100
      # And add the days to the date
      start.setDate start.getDate() + daysCount
      # Then returns the new datte
      start
    # Get the width style of the given figure in propertion to the total
    $scope.figureStyle = (figure)->
      return unless $scope.day?
      data = $scope.day.regional_data
      total = data.death_total + data.cases_total + data.admitted_msf_cumulative_w + data.recovered_msf_cumulative
      if total is 0
        width: Math.round(100/4) + "%"
      else
        width: Math.round(figure/total*100) + "%"
    # Only show place with new cases
    $scope.popoverFilter = (place)-> ( place.weekly_new_cases ? 0 ) > 0
    # Update the day data
    $scope.$watch 'progress', ->
      $scope.today = $scope.progressDate()
      current = $scope.today.getTime() / 1000
      $scope.day = null
      for data in days
        break if 1*data.timestamp > current
        $scope.day = data
      # Customize icons for each center
      $scope.centers = _.map centers, createCenter
      # Remove empty one
      $scope.centers = _.filter $scope.centers, (c)-> c?
      # Find the last highlight
      highlight = do $scope.lastHighlight
      # There is a new highlight
      if highlight? and $scope.highlight isnt highlight
        # Stop this animation if there is an highlight visible
        $rootScope.$broadcast "main:cancel"
        # Save the highlight
        $scope.highlight = highlight
        # Start again in a few milliseconds
        $timeout (->$rootScope.$broadcast "main:play"), highlight.duration

    # Wait for click on marker
    $scope.$on 'leafletDirectiveMarker.click', openCenter
    # The animation starts
    $scope.$on 'main:play', -> $scope.isAnimating = yes
    # The animation stops
    $scope.$on 'main:end', ->
      $scope.isAnimating = no
      $scope.displayFinalHighlight = yes
    # The animation is skiped
    $scope.$on 'main:skip', ->
      $scope.isAnimating = no
      $scope.displayFinalHighlight = no
