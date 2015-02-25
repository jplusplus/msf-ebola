angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        url:"/main"
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
