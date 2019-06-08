# CHANGELOG

## [0.0.1+8] - 2019/06/08

* Added method to get all themes: `ThemeProvider.controllerOf(context).allThemes`
* Made theme id reqired (instead of optional)
* Added optional description field to theme
* Added  dialog to switch themes

## [0.0.1+7] - 2019/06/08

* Removed dependency on Provider.

## [0.0.1+6] - 2019/06/08

* Changed directory structure
* Ranamed,
  * `ThemeCommand.of(context)` to `ThemeProvider.controllerOf(context)`
  * `AppThemeOptions.of(context)` to `ThemeProvider.optionsOf(context)`
* Added `ThemeProvider.themeOf(context)` to get theme.

## [0.0.1+5] - 2019/06/08

* Improved documentation

## [0.0.1+4] - 2019/06/08

* Added default values to themes. Now it is not required
* Added AppTheme.light() and AppTheme.dark() to create dark and light themes easily
* Added command, setTheme(id)
* Imporved tests

## [0.0.1+3] - 2019/06/08

* Fix a bug in the example

## [0.0.1+2] - 2019/06/08

* Changed api to pass on theme to help apply the theme to app

## [0.0.1+1] - 2019/06/08

* Fixed major bug relating to ProviderNotFoundError

## [0.0.1] - 2019/06/08

* Added base functionality to add custome theme data
* Added functionality to cycle theme using the command
