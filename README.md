# spamtabulator

## Quick way to gather stats on line spam from the game

The goal of this package is to assist me in gathering real world data on how many lines of text are coming from some of the spam heavier games during spam heavy events. 

## Installation

The easiest way to install spamtabulator is with the following command in the Mudlet command line. Once it is installed for the first time, you can use `spamtab update` and it will do it for you.

`lua uninstallPackage("spamtabulator") installPackage("https://github.com/demonnic/spamtabulator/releases/latest/download/spamtabulator.mpackage")`

## Usage

This is a pretty basic package. Use `spamtab <start|stop>` to turn the spam tabulator on or off. It will upload the data to me when you turn it off.

### Aliases

* `spamtab`
  * toggles the spamtabulator state. If it is on, it will get turned off. And vice versa.
* `spamtab start`
  * turns the spamtabulator on
* `spamtab stop`
  * turns the spamtabulator off and uploads the data to demonnic
* `spamtab update`
  * uninstalls spamtabulator and installs the latest version. No check for what version you have, so it can be used to repair a broken spamtabulator installation
