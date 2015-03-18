angular.module "msfEbola"
  .controller "MenuCtrl", ($scope, $translate, $state, index, Share) ->
    $scope.languages = index.languages.sort()
    $scope.useLanguage = (lang)->
      $translate.use(lang)
      $scope.showLanguages = no
    # Open the share popup
    $scope.share = Share.open
    # Consider that we are animating by default
    $scope.isAnimating = no
    # The animation starts
    $scope.$on 'main:play', -> $scope.isAnimating = yes
    # The animation stops
    $scope.$on 'main:end', -> $scope.isAnimating = no
