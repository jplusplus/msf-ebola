angular.module('msfEbola')
  .directive 'draggable', ($document) ->
    restrict: 'AE'
    require: 'ngModel'
    link: (scope, element, attr, ngModel) ->
      parent = element.parent()
      startX = x = 0
      # True when the received event is from a touch device
      isTouch = (event)-> event.type.indexOf('touch') is 0

      mousemove = (event) ->
        # Use a different event on touch devices
        ref= if isTouch event then event.originalEvent.touches[0] else event
        x  = ref.pageX - startX
        px = x/parent.width()*100
        px = Math.max( Math.min(px, 100), 0)
        # Move the element alongside its parent
        element.css left: px + '%'
        # Update model value
        ngModel.$setViewValue px

      mouseup = ->
        $document.off 'mousemove touchmove', mousemove
        $document.off 'mouseup touchend', mouseup

      scope.$watch attr.ngModel, (px)->
        x = (px or 0)/100 * parent.width()
        element.css cursor: 'move', left: (px or 0) + '%'

      element.on 'mousedown touchstart', (event) ->
        # Prevent default dragging of selected content
        event.preventDefault()
        # Use a different event on touch devices
        ref= if isTouch event then event.originalEvent.touches[0] else event
        startX = ref.pageX - x
        $document.on 'mousemove touchmove', mousemove
        $document.on 'mouseup touchend', mouseup
