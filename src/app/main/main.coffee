angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "main",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
