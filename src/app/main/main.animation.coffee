angular.module "msfEbola"
  .animation '.victims-animation', ->
    removeClass: (element, className, done) ->
      if className is 'ng-hide'
        victims = element.find ".main__weeks__slot__victim"
        # The total animation must be 500 ms
        victim_delay = 500/victims.length
        # Initial state of the victims
        victims.css(opacity: 0)
        victims.each (i)->
          delay = i * victim_delay
          $(this).delay(delay).animate { opacity:1 },
            duration: 100
            easing: 'linear'
        setTimeout done, 500
      else do done
