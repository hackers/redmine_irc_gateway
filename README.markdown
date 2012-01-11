Redmine IRC Gateway [![Build Status](https://secure.travis-ci.org/hackers/redmine_irc_gateway.png)](https://secure.travis-ci.org/hackers/redmine_irc_gateway) [![Still Maintained](http://stillmaintained.com/hackers/redmine_irc_gateway.png)](http://stillmaintained.com/hackers/redmine_irc_gateway)
================================================================================


Overview
-------------------------------------------------------------------------------

### What's this?

This project provides an access to Redmine API via IRC Gateway.


Installation
-------------------------------------------------------------------------------

### Requirements

- RVM
- Ruby 1.9.2+
- RubyGems
    - Rake
    - Bundler


### Create development environment

1. Clone Git repository

        $ git clone git@github.com:hackers/redmine_irc_gateway.git
        $ cd redmine_irc_gateway

2. Installing RubyGems

    Bundler

        $ bundle install --path vendor/bundle



How to use
-------------------------------------------------------------------------------

### Make configuration file

Rename configuration file

    $ mv config/config.yml.example config/config.yml

or

    $ mkdir ~/.rig
    $ mv config/config.yml.example ~/.rig/config.yml

Edit config/config.yml or $HOME/.rig/config.yml. See `config/config.yml.example`.


### Run, and stay on top

    $ lib/redmine_irc_gateway.rb

If you want to use debug mode, add the `--debug` option. like this.

    $ lib/redmine_irc_gateway.rb --debug

#### Bundler

    $ bundle exec ruby lib/redmine_irc_gateway.rb


### Process daemonize

#### Start

    $ bundle exec ./bin/rig start

#### Stop

    $ bundle exec ./bin/rig stop

#### Restart

    $ bundle exec ./bin/rig restart

#### Kill

    $ bundle exec ./bin/rig kill

### Cleaning environment

    $ rake clean


IRC Channel
-------------------------------------------------------------------------------

`#rig` at Freenode.net


Author
-------------------------------------------------------------------------------

- Tomohiro, TAIRA [@Tomohiro](http://twitter.com/Tomohiro)


Contributors
-------------------------------------------------------------------------------

- Naoto, SHINGAKI [@naotos](http://twitter.com/naotos)
- Yusaku, ONO [@yono](http://twitter.com/yono)


LICENSE
-------------------------------------------------------------------------------

This project is dual licensed under the MAHALO license or GPL Version 2 licenses.
See LICENSE for details.
