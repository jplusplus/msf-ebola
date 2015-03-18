angular.module('msfEbola')
  .directive 'main', ($rootScope, $state, main) ->
    restrict: 'C'
    require: 'ngModel'
    link: (scope, element, attr, ngModel)->
      # Elements
      anchor = element.find(".main__timeline__anchor")
      parent = anchor.parent()
      # Starting day
      day = 0
      # Calculates the progression of the frame
      anchor_frame = -> anchor.css("left").replace("px", "") / parent.width()
      # Function to start the animation
      start = ->
        # Starts the animation
        anchor.velocity { left: '100%' },
          duration: ( 1 - do anchor_frame ) * main.duration,
          easing: 'linear',
          progress: ->
            # Calculate the position of the anchor dynamicly
            frame = do anchor_frame
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
      scope.$on "main:skip", -> anchor.velocity "stop"
      # Notice the begining of the animation (or not)
      next = if $state.params.skip is "1" then "main:skip" else "main:play"
      $rootScope.$broadcast next
