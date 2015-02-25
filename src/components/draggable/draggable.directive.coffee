angular.module('msfEbola')
  .directive 'draggable', ($document) ->
    restrict: 'AE'
    require: 'ngModel'
    link: (scope, element, attr, ngModel) ->
      parent = element.parent()
      startX = x = 0

      mousemove = (event) ->
        x  = event.pageX - startX
        px = x/parent.width()*100
        px = Math.max( Math.min(px, 100), 0)
        # Move the element alongside its parent
        element.css left: px + '%'
        # Update model value
        ngModel.$setViewValue px

      mouseup = ->
        $document.off 'mousemove', mousemove
        $document.off 'mouseup', mouseup

      scope.$watch attr.ngModel, (px)->
        x = (px or 0)/100 * parent.width()
        element.css cursor: 'grab', left: (px or 0) + '%'

      element.on 'mousedown', (event) ->
        # Prevent default dragging of selected content
        event.preventDefault()
        startX = event.pageX - x
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup
