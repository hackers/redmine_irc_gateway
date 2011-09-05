Redmine IRC Gateway [![Build Status](http://secure.travis-ci.org/hackers/redmine_irc_gateway.png)](http://secure.travis-ci.org/hackers/redmine_irc_gateway) [![Still Maintained](http://stillmaintained.com/hackers/redmine_irc_gateway.png)](http://stillmaintained.com/hackers/redmine_irc_gateway)
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

1. Clone git repo

        $ git clone git@github.com:hackers/redmine_irc_gateway.git
        $ cd redmine_irc_gateway

2. Installing Ruby and libraries

        $ rvm install 1.9.2
        $ rake rig:development:setup


How to use
-------------------------------------------------------------------------------

### Make configuration file

Rename configuration files

    mv config/config.yml.example config/config.yml

Edit config/config.yml

    server:
        site: ${REDMINE_URI}
    channels:
        ChannelName: project id
        AwsomeProject: 777


### Run, and stay on top

    $ lib/redmine_irc_gateway.rb

If you want to use debug mode, add the `--debug` option. like this.

    $ lib/redmine_irc_gateway.rb --debug


### Process daemonize

#### Start

    $ bin/rig start

#### Stop

    $ bin/rig stop

#### Restart

    $ bin/rig restart


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
