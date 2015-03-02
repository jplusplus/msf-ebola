angular.module('msfEbola')
  .directive 'main', ($rootScope, main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      day = 0
      $rootScope.$broadcast "main:start"
      element.find(".main__timeline__anchor")
        .animate { left: '100%' },
          duration: main.duration,
          easing: 'linear',
          step: (frame)->
            now = ~~(365 * frame/100)
            # Update the view value when the current
            # day is bigger than the last one
            if now > day
              ngModel.$setViewValue frame
              # Update the parent controller render
              do ngModel.$render
              # Save the last day
              day = now
          done: ->
            $rootScope.$apply ->
              $rootScope.$broadcast "main:end"
