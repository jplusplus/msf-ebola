angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        url: "/m?skip"
        params:
          skip:
            value: 0
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
        resolve:
          # Hghlighted moments in the timeline
          highlights: ($http)->
            $http.get("assets/json/highlights.json", cache: yes).then (d)->
              # Prepare each highlight
              for highlight in d.data
                highlight.date_start = (new Date highlight.date_start).getTime()
              d.data
          # Data day after day
          days: ($http)-> $http.get("assets/json/days.json", cache: yes).then (d)-> d.data
          # Data aggregated by weeks
          aggregation: ($http)-> $http.get("assets/json/aggregation.json", cache: yes).then (d)-> d.data
          # Data per center
          centers: ($http)-> $http.get("assets/json/centers.json", cache: yes).then (d)-> d.data
