angular.module('msfEbola').config ($stateProvider) ->
  $stateProvider.state 'about',
    url: "/about"
    templateUrl: "app/about/about.html"
