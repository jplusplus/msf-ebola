angular.module "msfEbola"
  .controller "MenuCtrl", ($scope, $translate, index, Share) ->
    $scope.languages = index.languages.sort()
    $scope.useLanguage = (lang)->
      $translate.use(lang)
      $scope.showLanguages = no
    # Open the share popup
    $scope.share = Share.open
