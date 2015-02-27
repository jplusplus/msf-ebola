# MSF: Ebola

[Download](https://github.com/jplusplus/msf-ebola/archive/gh-pages.zip) • [Fork](https://github.com/jplusplus/msf-ebola) • [License](https://github.com/jplusplus/msf-ebola/blob/master/LICENSE)  •
by [Journalism++](http://jplusplus.org/) under GNU Lesser General Public License

## Installation

Install `node` and `npm` then run:

```bash
make install
```

You can now start serving static files with gulp!

```bash
make run
```

## Configure Crowdin *(optional)*

This project relies on Crowdin to manage interface translations. To be able to submit and download translations from Crowdin, you have to follow 2 simple steps.

**Create a copy of Crozdin configuration file:**

```bash
cp crowdin.yaml.template crowdin.yaml
```

**Edit the new file ```crowdin.yaml``` to add your API key ([grab it here](https://crowdin.com/project/msf-ebola-one-year/settings#api)):**


```yaml
project_identifier: msf-ebola-one-year
base_url: https://api.crowdin.com
preserve_hierarchy: true
api_key: <ADD YOUR API KEY HERE>

files:
  -
    source: /src/assets/json/en.json
    translation: /src/assets/json/%two_letters_code%.json
```

You can now run ```make crowdin_download``` to grab translations from the Crowdin website.

## Available commands

Command | Description
--- | ---
`make build` | Build the app to the `dist` directory
`make crowdin_download` | Downloads locales from Crowdin
`make crowdin_upload` | Uploads locales to Crowdin
`make deploy` | Deploys the app on Github Pages
`make full_deploy` | Downloads locales from Crowdin, commits changes and deploys on Github Pages
`make install` | Downloads all app's components
`make run` | Runs the development server on port *3000*
`make zip` | Builds and exports the app to a zip file


## Technical stack

This small application uses the following tools and opensource projects:

* [AngularJS](https://angularjs.org/) - Javascript Framework
* [Yeoman: gulp-angular](https://github.com/Swiip/generator-gulp-angular) - Static app generator
* [Leaflet: Angular Directive](http://tombatossals.github.io/angular-leaflet-directive/) - Leaflet Map with Angular
* [UI Router](https://github.com/angular-ui/ui-router/) - Application states manager
* [LoDash](http://lodash.com/) - Utility library
* [Bootstrap](http://getbootstrap.com/) - HTML and CSS framework
* [Less](http://lesscss.org/) - CSS pre-processor
* [CoffeeScript](http://coffeescript.org/) - Javascript pre-processor
