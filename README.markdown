Redmine IRC Gateway [![Build Status](https://secure.travis-ci.org/hackers/redmine_irc_gateway.png)](http://travis-ci.org/hackers/redmine_irc_gateway) [![Still Maintained](http://stillmaintained.com/hackers/redmine_irc_gateway.png)](http://stillmaintained.com/hackers/redmine_irc_gateway)
================================================================================


Overview
-------------------------------------------------------------------------------

### What's this?

This project privides an access to Redmine API via IRC Gateway.
But, yet not working ;-p


Installation
-------------------------------------------------------------------------------

### Requirements

- RVM
- Ruby 1.8.7
- RubyGems
    - Rake
    - Bundler


### Create development environment

1. Clone git repo

        $ git clone git@github.com:hackers/redmine_irc_gateway.git
        $ cd redmine_irc_gateway

2. Installing Ruby and libraries

        $ rvm install 1.8.7
        $ rake rig:development:setup


How to use
-------------------------------------------------------------------------------

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


Authors
-------------------------------------------------------------------------------

Tomohiro, TAIRA a.k.a [@Tomohiro](http://twitter.com/Tomohiro) (tomohiro.t@gmail.com)

Naoto, Shingaki a.k.a [@naotos](http://twitter.com/naotos) (n.shingaki@gmail.com)

Yusaku, Ono a.k.a [@yono](http://twitter.com/yono) (yono.05@gmail.com)

LICENSE
-------------------------------------------------------------------------------

This project is dual licensed under the MAHALO license or GPL Version 2 licenses.
See LICENSE for details.
