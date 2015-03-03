angular.module('msfEbola')
  .directive 'main', ($rootScope, main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      day = 0
      # Starts the animation
      element.find(".main__timeline__anchor")
        .velocity { left: '100%' },
          duration: main.duration,
          easing: 'linear',
          progress: (element, frame)->
            now = ~~(365 * frame)
            # Update the view value when the current
            # day is bigger than the last one
            if now > day
              ngModel.$setViewValue frame*100
              # Update the parent controller render
              do ngModel.$render
              # Save the last day
              day = now
          complete: ->
            $rootScope.$apply ->
              # Notice the end of the animation
              $rootScope.$broadcast "main:end"
      # Stops the animation
      scope.$on "main:cancel", ->
        # Use velocity method to stop the animation
        element.find(".main__timeline__anchor").velocity "stop"
        # Notice the end of the animation
        $rootScope.$broadcast "main:end"
      # Notice the begining of the animation
      $rootScope.$broadcast "main:start"
