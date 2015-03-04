angular.module("msfEbola")
  .controller "ShareCtrl", ($scope, $modalInstance, $state)->
    $scope.close = $modalInstance.close
    $scope.getIframe = ->
      url    = $state.href 'main', {}, absolute: yes
      width  = '100%'
      height = 600
      '<iframe src="' + url + '" width="' + width + '" height="' + height + '" frameborder="0" allowfullscreen></iframe>'
