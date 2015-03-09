angular.module "msfEbola"
  .controller "IntroductionCtrl", ($scope, $stateParams, $state, hotkeys) ->
    $scope.step = $stateParams.step or 0
    $scope.next =  ->
      if $scope.step < 3
        $scope.step++
      else
        $state.go 'main'

    hotkeys.add
      combo: ['space', 'right']
      description: "Go to the next screen."
      callback: $scope.next
