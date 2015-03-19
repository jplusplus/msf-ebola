angular.module "msfEbola"
  .controller "IntroductionCtrl", ($scope, $stateParams, $state, $stateParams, $translate, hotkeys) ->  	
    $scope.step = $stateParams.step or 0
    $scope.next =  ->
      if $scope.step < 3
        $scope.step++
      else
        $state.go 'main'

    $translate.use $stateParams.lang if $stateParams.lang?

    hotkeys.add
      combo: ['space', 'right']
      description: "Go to the next screen."
      callback: $scope.next
