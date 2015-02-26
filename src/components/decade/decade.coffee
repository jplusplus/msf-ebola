angular.module("msfEbola")
  .filter "decade", ->
    (number=0)->
      Math.round(number/10)*10
