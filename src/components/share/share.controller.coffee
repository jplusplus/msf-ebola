angular.module("msfEbola")
  .controller "ShareCtrl", ($scope, $modalInstance, $state)->
    $scope.close = $modalInstance.close
    $scope.getIframe = ->
      url    = $state.href 'introduction', {}, absolute: yes
      width  = '100%'
      height = 650
      '<iframe src="' + url + '" width="' + width + '" height="' + height + '" frameborder="0" allowfullscreen></iframe>'
