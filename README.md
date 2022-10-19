oclif-hello-world
=================

oclif example Hello World CLI

[![oclif](https://img.shields.io/badge/cli-oclif-brightgreen.svg)](https://oclif.io)
[![Version](https://img.shields.io/npm/v/oclif-hello-world.svg)](https://npmjs.org/package/oclif-hello-world)
[![CircleCI](https://circleci.com/gh/oclif/hello-world/tree/main.svg?style=shield)](https://circleci.com/gh/oclif/hello-world/tree/main)
[![Downloads/week](https://img.shields.io/npm/dw/oclif-hello-world.svg)](https://npmjs.org/package/oclif-hello-world)
[![License](https://img.shields.io/npm/l/oclif-hello-world.svg)](https://github.com/oclif/hello-world/blob/main/package.json)

<!-- toc -->
* [Usage](#usage)
* [Commands](#commands)
<!-- tocstop -->
# Usage
<!-- usage -->
```sh-session
$ npm install -g trulybuzzy
$ trulybuzzy COMMAND
running command...
$ trulybuzzy (--version)
trulybuzzy/0.0.0 linux-x64 node-v16.5.0
$ trulybuzzy --help [COMMAND]
USAGE
  $ trulybuzzy COMMAND
...
```
<!-- usagestop -->
# Commands
<!-- commands -->
* [`trulybuzzy hello PERSON`](#trulybuzzy-hello-person)
* [`trulybuzzy hello world`](#trulybuzzy-hello-world)
* [`trulybuzzy help [COMMAND]`](#trulybuzzy-help-command)
* [`trulybuzzy plugins`](#trulybuzzy-plugins)
* [`trulybuzzy plugins:install PLUGIN...`](#trulybuzzy-pluginsinstall-plugin)
* [`trulybuzzy plugins:inspect PLUGIN...`](#trulybuzzy-pluginsinspect-plugin)
* [`trulybuzzy plugins:install PLUGIN...`](#trulybuzzy-pluginsinstall-plugin-1)
* [`trulybuzzy plugins:link PLUGIN`](#trulybuzzy-pluginslink-plugin)
* [`trulybuzzy plugins:uninstall PLUGIN...`](#trulybuzzy-pluginsuninstall-plugin)
* [`trulybuzzy plugins:uninstall PLUGIN...`](#trulybuzzy-pluginsuninstall-plugin-1)
* [`trulybuzzy plugins:uninstall PLUGIN...`](#trulybuzzy-pluginsuninstall-plugin-2)
* [`trulybuzzy plugins update`](#trulybuzzy-plugins-update)

## `trulybuzzy hello PERSON`

Say hello

```
USAGE
  $ trulybuzzy hello [PERSON] -f <value>

ARGUMENTS
  PERSON  Person to say hello to

FLAGS
  -f, --from=<value>  (required) Who is saying hello

DESCRIPTION
  Say hello

EXAMPLES
  $ oex hello friend --from oclif
  hello friend from oclif! (./src/commands/hello/index.ts)
```

_See code: [dist/commands/hello/index.ts](https://github.com/tim-field/trulybuzzy/blob/v0.0.0/dist/commands/hello/index.ts)_

## `trulybuzzy hello world`

Say hello world

```
USAGE
  $ trulybuzzy hello world

DESCRIPTION
  Say hello world

EXAMPLES
  $ trulybuzzy hello world
  hello world! (./src/commands/hello/world.ts)
```

## `trulybuzzy help [COMMAND]`

Display help for trulybuzzy.

```
USAGE
  $ trulybuzzy help [COMMAND] [-n]

ARGUMENTS
  COMMAND  Command to show help for.

FLAGS
  -n, --nested-commands  Include all nested commands in the output.

DESCRIPTION
  Display help for trulybuzzy.
```

_See code: [@oclif/plugin-help](https://github.com/oclif/plugin-help/blob/v5.1.14/src/commands/help.ts)_

## `trulybuzzy plugins`

List installed plugins.

```
USAGE
  $ trulybuzzy plugins [--core]

FLAGS
  --core  Show core plugins.

DESCRIPTION
  List installed plugins.

EXAMPLES
  $ trulybuzzy plugins
```

_See code: [@oclif/plugin-plugins](https://github.com/oclif/plugin-plugins/blob/v2.1.1/src/commands/plugins/index.ts)_

## `trulybuzzy plugins:install PLUGIN...`

Installs a plugin into the CLI.

```
USAGE
  $ trulybuzzy plugins:install PLUGIN...

ARGUMENTS
  PLUGIN  Plugin to install.

FLAGS
  -f, --force    Run yarn install with force flag.
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Installs a plugin into the CLI.

  Can be installed from npm or a git url.

  Installation of a user-installed plugin will override a core plugin.

  e.g. If you have a core plugin that has a 'hello' command, installing a user-installed plugin with a 'hello' command
  will override the core plugin implementation. This is useful if a user needs to update core plugin functionality in
  the CLI without the need to patch and update the whole CLI.

ALIASES
  $ trulybuzzy plugins add

EXAMPLES
  $ trulybuzzy plugins:install myplugin 

  $ trulybuzzy plugins:install https://github.com/someuser/someplugin

  $ trulybuzzy plugins:install someuser/someplugin
```

## `trulybuzzy plugins:inspect PLUGIN...`

Displays installation properties of a plugin.

```
USAGE
  $ trulybuzzy plugins:inspect PLUGIN...

ARGUMENTS
  PLUGIN  [default: .] Plugin to inspect.

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Displays installation properties of a plugin.

EXAMPLES
  $ trulybuzzy plugins:inspect myplugin
```

## `trulybuzzy plugins:install PLUGIN...`

Installs a plugin into the CLI.

```
USAGE
  $ trulybuzzy plugins:install PLUGIN...

ARGUMENTS
  PLUGIN  Plugin to install.

FLAGS
  -f, --force    Run yarn install with force flag.
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Installs a plugin into the CLI.

  Can be installed from npm or a git url.

  Installation of a user-installed plugin will override a core plugin.

  e.g. If you have a core plugin that has a 'hello' command, installing a user-installed plugin with a 'hello' command
  will override the core plugin implementation. This is useful if a user needs to update core plugin functionality in
  the CLI without the need to patch and update the whole CLI.

ALIASES
  $ trulybuzzy plugins add

EXAMPLES
  $ trulybuzzy plugins:install myplugin 

  $ trulybuzzy plugins:install https://github.com/someuser/someplugin

  $ trulybuzzy plugins:install someuser/someplugin
```

## `trulybuzzy plugins:link PLUGIN`

Links a plugin into the CLI for development.

```
USAGE
  $ trulybuzzy plugins:link PLUGIN

ARGUMENTS
  PATH  [default: .] path to plugin

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Links a plugin into the CLI for development.

  Installation of a linked plugin will override a user-installed or core plugin.

  e.g. If you have a user-installed or core plugin that has a 'hello' command, installing a linked plugin with a 'hello'
  command will override the user-installed or core plugin implementation. This is useful for development work.

EXAMPLES
  $ trulybuzzy plugins:link myplugin
```

## `trulybuzzy plugins:uninstall PLUGIN...`

Removes a plugin from the CLI.

```
USAGE
  $ trulybuzzy plugins:uninstall PLUGIN...

ARGUMENTS
  PLUGIN  plugin to uninstall

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Removes a plugin from the CLI.

ALIASES
  $ trulybuzzy plugins unlink
  $ trulybuzzy plugins remove
```

## `trulybuzzy plugins:uninstall PLUGIN...`

Removes a plugin from the CLI.

```
USAGE
  $ trulybuzzy plugins:uninstall PLUGIN...

ARGUMENTS
  PLUGIN  plugin to uninstall

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Removes a plugin from the CLI.

ALIASES
  $ trulybuzzy plugins unlink
  $ trulybuzzy plugins remove
```

## `trulybuzzy plugins:uninstall PLUGIN...`

Removes a plugin from the CLI.

```
USAGE
  $ trulybuzzy plugins:uninstall PLUGIN...

ARGUMENTS
  PLUGIN  plugin to uninstall

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Removes a plugin from the CLI.

ALIASES
  $ trulybuzzy plugins unlink
  $ trulybuzzy plugins remove
```

## `trulybuzzy plugins update`

Update installed plugins.

```
USAGE
  $ trulybuzzy plugins update [-h] [-v]

FLAGS
  -h, --help     Show CLI help.
  -v, --verbose

DESCRIPTION
  Update installed plugins.
```
<!-- commandsstop -->
