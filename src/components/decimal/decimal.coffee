# @src https://github.com/ianstormtaylor/to-title-case
angular.module("msfEbola").filter "decimal", ($translate)->
  (number='', mark=$translate.instant('decimal_mark') )-> (number + '').replace /\./, mark
