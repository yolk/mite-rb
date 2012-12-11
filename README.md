## mite-rb

The official ruby library for interacting with the [RESTful API](http://mite.yo.lk/en/api) of [mite](http://mite.yo.lk/en), a sleek time tracking webapp.

## Install

Install the lib as a ruby gem:

    gem install mite-rb

mite-rb requires activeresource and activesupport in version 3.1 or above. If you want/need to use it with activeresource 2.3.14 to 3.0.9 please use mite-rb 0.4.5.

## Documentation

You should read the complete *mite*.api documentation at [http://mite.yo.lk/en/api](http://mite.yo.lk/en/api)

### Authenticate

**IMPORTANT:** To use mite-rb you **must** enable the *mite*.api for your user within the webinterface of *mite*! It is disabled by default.

The first thing you need to set is the account name.  This is the same as the web address (subdomain) for your account. For example if you use *mite* from the domain *demo.mite.yo.lk* set the account to 'demo':

    Mite.account = 'demo'

Then, you should set the authentication. You can either use your mite.api key (recommended) or your login credentials (email and password).

    Mite.key = 'cdfeasdaabcdefgssaeabcdefg'

or

    Mite.authenticate('rick@techno-weenie.net', 'spacemonkey')

### User-Agent

mite-rb sets the User-Agent HTTP-header to 'mite-rb/0.3.0' by default. You can (and should) customize it to a more specific one:

    Mite.user_agent = 'my-mighty-mite-addon/1.2.3'

You can combine your custom string with the default one:

    Mite.user_agent = "my-mighty-mite-addon/1.2.3;#{Mite.user_agent}"

### Validate connection

You can validate the connection/authentication with

    Mite.validate

This will return true when the connection is valid and false if not.

Use

    Mite.validate!

and mite-rb will raise an exception with further details when the connection is not valid.

### Project

#### Find all active projects

    Mite::Project.all

#### Find all archived projects

    Mite::Project.archived

#### Find projects where name contains 'web'

    Mite::Project.all(:params => {:name => 'web'})

#### Find single project by ID

    Mite::Project.find(1209)

#### Get all time entries of a project

    project = Mite::Project.find(1209)
    project.time_entries

#### Get the customer of a project

    project = Mite::Project.find(1209)
    project.customer

#### Creating

    project = Mite::Project.new(:name => 'Playing with the mite.api')
    project.save

or in a single step

    project = Mite::Project.create(:name => 'Playing with the mite.api')

#### Updating

    project = Mite::Project.find(1209)
    project.name = "mite.api"
    project.customer = Mite::Customer.find(384)
    project.save

#### Deleting

    project = Mite::Project.find(1209)
    project.destroy


