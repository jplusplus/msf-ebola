angular.module('msfEbola')
  .directive 'draggable', ($document) ->
    restrict: 'AE'
    require: 'ngModel'
    link: (scope, element, attr, ngModel) ->
      parent = element.parent()
      startX = x = perc = 0
      # True when the received event is from a touch device
      isTouch = (event)-> event.type.indexOf('touch') is 0

      mousemove = (event) ->
        # Use a different event on touch devices
        ref= if isTouch event then event.originalEvent.touches[0] else event
        x  = ref.pageX - startX
        perc = x/parent.width()*100
        perc = Math.max( Math.min(perc, 100), 0)
        # Move the element alongside its parent
        element.css left: perc + '%'
        # Update model value
        ngModel.$setViewValue perc

      mouseup = ->
        $document.off 'mousemove touchmove', mousemove
        $document.off 'mouseup touchend', mouseup


      scope.$watch attr.ngModel, (perc)->
        x = (perc or 0)/100 * parent.width()
        element.css cursor: 'move', left: (perc or 0) + '%'

      element.on 'mousedown touchstart', (event) ->
        # Prevent default dragging of selected content
        event.preventDefault()
        x = (ngModel.$viewValue or 0)/100 * parent.width()
        # Use a different event on touch devices
        ref= if isTouch event then event.originalEvent.touches[0] else event
        startX = ref.pageX - x
        $document.on 'mousemove touchmove', mousemove
        $document.on 'mouseup touchend', mouseup
