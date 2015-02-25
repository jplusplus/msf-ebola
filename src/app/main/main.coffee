angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        url:"/main"
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
        resolve:
          # Data day after day
          days: ($http)-> $http.get("assets/json/days.json").then (d)-> d.data
          # Data per center
          centers: ($http)-> $http.get("assets/json/centers.json").then (d)-> d.data
