# CHANGELOG

## [0.4.0+1]

* Updated readme to change the recommended method of wrapping the app with the `ThemeProvider`.

## [0.4.0]

* Added the ability to add/remove themes dynamically. [#9](https://github.com/kdsuneraavinash/theme_provider/issues/9)
* Added docs to describe on automatic theme mode detection on startup. [#7](https://github.com/kdsuneraavinash/theme_provider/issues/7)
* Bumped `shared_preferences` version
* BREAKING CHANGE: Changed return type of `ThemeProvider.controllerOf` to `ThemeController` and removed `ThemeCommand` abstract class.

## [0.3.3]

* Added better error messages when description is not provided with theme. [#1](https://github.com/kdsuneraavinash/theme_provider/issues/1)
* Bumped `shared_preferences` version

## [0.3.2]

* Used `dependOnInheritedWidgetOfExactType` instead of `inheritFromWidgetOfExactType`.
* Modified README

## [0.3.1]

* Added ability to add a `onThemeChanged` callback to `ThemeProvider` to be called after each time the theme is switched.

## [0.3.0]

* Changed `ThemeProvider` to accept a child instead of builder.
* Added `ThemeConsumer` widget.
* Added `loadThemeOnInit` parameter.
* Added `providerId` parameter to allow multiple theme providers.

## [0.2.0+3] - 2019/06/25

* Added `onInitCallback` parameter to ThemeProvider.
* Modified README

## [0.2.0+2] - 2019/06/11

* Now theme can be saved manually using `ThemeProvider.controllerOf(context).saveThemeToDisk()`
* Modified README

## [0.2.0+1] - 2019/06/11

* Fixed some typo and updated README and bumped example theme_provider version.

## [0.2.0] - 2019/06/10

* BREAKING CHANGE: `loadThemesOnStartup` is no longer supported. Use `ThemeProvider.controllerOf(context).loadThemeFromDisk()` manually to load theme.

## [0.1.0+1] - 2019/06/09

* Fixed some typos in code

## [0.1.0] - 2019/06/09

* BREAKING CHANGE: Removed context parameter from `ThemeProvider` builder.

## [0.0.1+10] - 2019/06/09

* Added ability to provide default theme id.
* Added ability to persist current theme.

## [0.0.1+9] - 2019/06/09

* Changed `ThemeProvider.themeOf(context)` to return the current `AppTheme`.
* Removed `currentThemeId` from `ThemeCommand`.

## [0.0.1+8] - 2019/06/08

* Added method to get all themes: `ThemeProvider.controllerOf(context).allThemes`
* Made theme id required (instead of optional)
* Added optional description field to theme
* Added  dialog to switch themes

## [0.0.1+7] - 2019/06/08

* Removed dependency on Provider.

## [0.0.1+6] - 2019/06/08

* Changed directory structure
* Renamed,
  * `ThemeCommand.of(context)` to `ThemeProvider.controllerOf(context)`
  * `AppThemeOptions.of(context)` to `ThemeProvider.optionsOf(context)`
* Added `ThemeProvider.themeOf(context)` to get theme.

## [0.0.1+5] - 2019/06/08

* Improved documentation

## [0.0.1+4] - 2019/06/08

* Added default values to themes. Now it is not required
* Added AppTheme.light() and AppTheme.dark() to create dark and light themes easily
* Added command, setTheme(id)
* Improved tests

## [0.0.1+3] - 2019/06/08

* Fix a bug in the example

## [0.0.1+2] - 2019/06/08

* Changed api to pass on theme to help apply the theme to app

## [0.0.1+1] - 2019/06/08

* Fixed major bug relating to ProviderNotFoundError

## [0.0.1] - 2019/06/08

* Added base functionality to add custom theme data
* Added functionality to cycle theme using the command
