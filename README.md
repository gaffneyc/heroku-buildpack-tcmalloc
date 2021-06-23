# heroku-buildpack-tcmalloc

[TCMalloc](https://github.com/gperftools/gperftools) is a thread-caching malloc
implementation designed to reduce fragmentation in multithreaded applications.
This buildpack makes it easy to install and use TCMalloc on Heroku and
compatible platforms.

## Install

```console
heroku buildpacks:add https://github.com/gaffneyc/heroku-buildpack-tcmalloc.git
git push heroku master
```

## Usage

### Recommended

Set the TCMALLOC_ENABLED config option to true and tcmalloc will be used for
all commands run inside of your dynos.

```console
heroku config:set TCMALLOC_ENABLED=true
```

### Per dyno

To control when tcmalloc is configured on a per dyno basis use
`tcmalloc.sh <cmd>` and ensure that TCMALLOC_ENABLED is unset.

Example Procfile:
```yaml
web: tcmalloc.sh bundle exec puma -C config/puma.rb
```

## Configuration

### TCMALLOC_ENABLED

Set this to true to automatically enable tcmalloc.

```console
heroku config:set TCMALLOC_ENABLED=true
```

To disable tcmalloc set the option to false. This will cause the application to
restart disabling tcmalloc.

```console
heroku config:set TCMALLOC_ENABLED=false
```

### TCMALLOC_VERSION

Set this to select or pin to a specific version of tcmalloc. The default is to
use the latest stable version if this is not set. You will receive an error
mentioning tar if the version does not exist.

**Default**: `2.7`

**note:** This setting is only used during slug compilation. Changing it will
require a code change to be deployed in order to take affect.

```console
heroku config:set TCMALLOC_VERSION=2.7
```

#### Available Versions

| Version                                                                         | Released   |
| ------------------------------------------------------------------------------- | ---------- |
| [2.7](https://github.com/gperftools/gperftools/releases/tag/gperftools-2.7)     | 2018-04-30 |
| [2.8](https://github.com/gperftools/gperftools/releases/tag/gperftools-2.8)     | 2020-07-06 |
| [2.8.1](https://github.com/gperftools/gperftools/releases/tag/gperftools-2.8.1) | 2020-12-21 |
| [2.9](https://github.com/gperftools/gperftools/releases/tag/gperftools-2.9)     | 2021-02-21 |
| [2.9.1](https://github.com/gperftools/gperftools/releases/tag/gperftools-2.9.1) | 2021-03-02 |

The complete and most up to date list of supported versions and stacks is
available on the [releases page.](https://github.com/gaffneyc/heroku-buildpack-tcmalloc/releases)

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```console
make VERSION=2.7
```

Artifacts will be dropped in `dist/` based on Heroku stack and tcmalloc version.

### Deploying New Versions

- `make VERSION=X.Y.Z`
- `open dist`
- Go to [releases](https://github.com/gaffneyc/heroku-buildpack-tcmalloc/releases)
- Edit the release corresponding to each heroku Stack
- Drag and drop the new build to attach

### Creating a New Stack
- Go to [releases](https://github.com/gaffneyc/heroku-buildpack-tcmalloc/releases)
- Click "Draft a new release"
- Tag is the name of the Stack (e.g. `heroku-18`)
- Target is `release-master`
- Title is `Builds for the [stack] stack`

## Thanks

Development of the TCMalloc buildpack is sponsored by [Dead Man's Snitch](https://deadmanssnitch.com),
a monitoring service for cron jobs and other scheduled tasks. Running backups,
invoicing, or other critical jobs on a regular basis? Dead Man's Snitch gives
you the peace of mind that they're actually working.
