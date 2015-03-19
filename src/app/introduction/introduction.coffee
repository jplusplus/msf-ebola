angular.module "msfEbola"
  .config ($stateProvider) ->
    $stateProvider
      .state "introduction",
        url: "/?lang",
        templateUrl: "app/introduction/introduction.html",
        controller: "IntroductionCtrl"
        params:
          step: null
        resolve:
          preload: ($q, $http)-> $q.all [
            $http.get "assets/json/days.json", cache: yes
            $http.get "assets/json/highlights.json", cache: yes
            $http.get "assets/json/centers.json", cache: yes
          ]
