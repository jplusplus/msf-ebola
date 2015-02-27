
angular.module "msfEbola"
  .config ($translateProvider, index) ->
    $translateProvider
      .useStaticFilesLoader
        prefix: 'assets/json/'
        suffix: '.json'
      .registerAvailableLanguageKeys index.languages
      .determinePreferredLanguage()
      .fallbackLanguage ['en']
      #.useMessageFormatInterpolation()
      .useCookieStorage()
