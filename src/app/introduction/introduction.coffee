angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "introduction",
        url: "/",
        templateUrl: "app/introduction/introduction.html",
        controller: "IntroductionCtrl"
        params:
          step: null
