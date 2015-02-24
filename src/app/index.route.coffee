angular.module "msfEbola"
  .config ($urlRouterProvider, $locationProvider) ->
    $urlRouterProvider.otherwise '/'
    $locationProvider.hashPrefix '!'
    $locationProvider.html5Mode no
  .run  ($rootScope, Progress, $location, $window) ->
    $rootScope.$on "$stateChangeStart", ->
      # Go to the top of the window
      $("body").scrollTo 0, 400
      # Start progress indicator
      do Progress.start
    $rootScope.$on "$stateChangeSuccess", ->
      # Stop progress indicator
      do Progress.complete
      # Send 'pageview' to Google Analytics
      $window.ga('send', 'pageview', page: $location.url()) if $window.ga?
    # Stop progress indicator
    $rootScope.$on "$stateChangeError", Progress.complete
