angular.module "msfEbola"
  .config ($translateProvider) ->
    $translateProvider
      .useStaticFilesLoader
        prefix: 'assets/json/'
        suffix: '.json'
      .registerAvailableLanguageKeys ['en', 'fr'],
        'en_US': 'en'
        'en_UK': 'en'
        'fr_FR': 'fr'
        'fr_CA': 'fr'
        'fr_BE': 'fr'
      .determinePreferredLanguage ->
        lang = navigator.language || navigator.userLanguage
        avalaibleKeys = [
          'en_US', 'en_UK', 'en',
          'fr_FR', 'fr_CA', 'fr_BE', 'fr'
        ]
        return if avalaibleKeys.indexOf(lang) is -1 then 'en' else lang
      .fallbackLanguage ['en', 'fr']
      .useMessageFormatInterpolation()
      .useCookieStorage()
