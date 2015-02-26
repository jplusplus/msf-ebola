angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        url:"/main"
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
        resolve:
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
