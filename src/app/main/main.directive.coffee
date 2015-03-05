angular.module('msfEbola')
  .directive 'main', ($rootScope, main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      # Elements
      anchor = element.find(".main__timeline__anchor")
      parent = anchor.parent()
      # Starting day
      day = 0
      # Function to start the animation
      start = ->
        # Starts the animation
        anchor.velocity { left: '100%' },
          duration: main.duration,
          easing: 'linear',
          progress: ->
            # Calculate the position of the anchor dynamicly
            frame = anchor.css("left").replace("px", "") / parent.width()
            # Calculate the current day
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
      # Starts the animation
      scope.$on "main:play", start
      # Stops the animation using velocity
      scope.$on "main:cancel", -> anchor.velocity "stop"
      # Notice the begining of the animation
      $rootScope.$broadcast "main:play"
