angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
        resolve:
          # Hghlighted moments in the timeline
          highlights: ($http)->
            $http.get("assets/json/highlights.json").then (d)->
              # Prepare each highlight
              for highlight in d.data
                highlight.date_start = (new Date highlight.date_start).getTime()
                highlight.date_end   = (new Date highlight.date_end).getTime()
              d.data
          # Data day after day
          days: ($http)-> $http.get("assets/json/days.json").then (d)->
            # Transform the days to an array
            days = _.reduce d.data, (array, day, timestamp)->
              day.timestamp = timestamp
              array.push day
              array
            , []
            # Order the array for quicker calculation
            _.sortBy days, 'timestamp'
          # Data per center
          centers: ($http)-> $http.get("assets/json/centers.json").then (d)-> d.data
