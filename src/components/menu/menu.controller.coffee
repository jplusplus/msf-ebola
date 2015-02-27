angular.module "msfEbola"
  .controller "MenuCtrl", ($scope, $translate, index) ->
    $scope.languages = index.languages.sort()
    $scope.useLanguage = (lang)->
      $translate.use(lang)
      $scope.showLanguages = no
