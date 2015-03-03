angular.module "msfEbola"
  .animation '.victims-animation', ->
    cascading =  (element, opacity, done)->
      victims = element.find ".main__weeks__slot__victim"
      # The total animation must be 500 ms
      victim_delay = 500/victims.length
      # Initial state of the victims
      victims.stop().css opacity: 1-opacity
      victims.each (i)->
        delay = i * victim_delay
        $(this).delay(delay).velocity opacity: opacity,
          duration: 100
          easing: 'linear'
      setTimeout done, 500
    beforeAddClass: (element, className, done)->
      if className is 'ng-hide'
        cascading element, 0, done
      return
    removeClass: (element, className, done) ->
      if className is 'ng-hide'
        cascading element, 1, done
      else do done
      return
