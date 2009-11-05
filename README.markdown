The official ruby library for interacting with the [RESTful API](http://mite.yo.lk/en/api) of [mite](http://mite.yo.lk/en), a sleek time tracking webapp.

## Install

As a ruby gem from gemcutter:
   
    sudo gem install mite-rb -s http://gemcutter.org

mite-rb requires activeresource and activesupport gems in a current version (2.3.2) to be installed.

## Documentation

You should read the complete mite.api documentation at http://mite.yo.lk/en/api

### Authenticate

The first thing you need to set is the account name.  This is the same as the web address (subdomain) for your account. For example if you use mite from the domain demo.mite.yo.lk:

    Mite.account = 'demo'

Then, you should set the authentication. You can either use your login credentials (email and password) with HTTP Basic Authentication or your mite.api key. In both cases you must enable the mite.api in your user settings.

With basic authentication:

    Mite.authenticate('rick@techno-weenie.net', 'spacemonkey')

or, use your api key:

    Mite.key = 'cdfeasdaabcdefgssaeabcdefg'

### Validate connection

You can validate the connection/authentication with

    Mite.validate
  
This will return true when the connection is valid and false if not.

Use

    Mite.validate!
  
and mite-rb will raise an exception with further details when the connection is not valid.

### Project

Find all active projects of the current account

    Mite::Project.all
   
Find single project by ID

    Mite::Project.find(1209)
 
Creating a Project

    project = Mite::Project.new(:name => 'Playing with the mite.api')
    project.save

or
 
    project = Mite::Project.create(:name => 'Playing with the mite.api') 
 
Updating a Project

    project = Mite::Project.find(1209)
    project.name = "mite.api"
    project.customer = Mite::Customer.find(384)
    project.save
 
Get the customer of an project

    project = Mite::Project.find(1209)
    project.customer
 
Deleting a project

    project = Mite::Project.find(1209)
    project.destroy


