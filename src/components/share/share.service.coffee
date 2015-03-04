angular.module 'msfEbola'
  .factory 'Share', ($modal)->
    new class Share
      open: =>
        do @close
        @modalInstance = $modal.open
          templateUrl: 'components/share/share.html'
          controller: 'ShareCtrl'
          size: 'lg'
      close: =>
        do @modelInstance.close if @modelInstance?
