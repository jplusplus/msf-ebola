angular.module('msfEbola')
  .directive 'main', ($rootScope, main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      day = 0
      $rootScope.$broadcast "main:start"
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
              $rootScope.$broadcast "main:end"
