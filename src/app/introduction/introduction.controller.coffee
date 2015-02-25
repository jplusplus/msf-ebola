angular.module "msfEbola"
  .controller "IntroductionCtrl", ($scope, $stateParams) ->
    $scope.step = $stateParams.step or 0
