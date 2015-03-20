angular.module('msfEbola').filter 'stripTags', ->
  (text, replacement='')-> String(text).replace(/<[^>]+>/gm, replacement)

