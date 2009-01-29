require File.dirname(__FILE__) + "/../mite-rb"

puts <<-TXT
Ruby lib for working with the Mite API's XML interface.
 
The first thing you need to set is the account name.  This is the same
as the web address (subdomain) for your account.
  
  # if you access mite under demo.mite.yo.lk
  Mite.account = 'demo'

Then, you should set the authentication. You can either use your login
credentials (email and password) with HTTP Basic Authentication 
or your mite api key. In both cases you must enable the mite.api in
your user settings.

  # with basic authentication
  Mite.authenticate('rick@techno-weenie.net', 'spacemonkey')

  # or, use your api key
  Mite.key = 'cdfeasdaabcdefgssaeabcdefg'

This library is a small wrapper around the REST interface.  You should read the docs at
http://mite.yo.lk/api.
TXT

include Mite