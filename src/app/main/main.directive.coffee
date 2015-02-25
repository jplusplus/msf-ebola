angular.module('msfEbola')
  .directive 'main', (main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      px = 0
      element.find(".main__timeline__anchor")
        .animate { left: '100%' },
          duration: main.duration,
          easing: 'linear',
          step: (now)->
            now = ~~now
            # Update the view value when the current
            # position is bigger than the last one
            if now > px
              ngModel.$setViewValue px = now
              # Update the parent controller render
              do ngModel.$render
