citytestapp
===========

Example Test App for The City

This is a Rails app that can be used as a plugin to The City.  It does the basic data decrypt and displays the information in various formats.  It also makes an API call to the authentication service to retrieves additional user data.

In order to get this sample to run, you will need to configure a couple of environment variables:

    $ THE_CITY_APP_SECRET=XXXXXXXXXXXXX
    $ THE_CITY_AUTH_URL=https://authentication.onthecity.org/authorization

 Alternately, you can specify a YAML file located at:  /config/thecity.yml, that has the following format:

    $ production:
    $   THE_CITY_APP_SECRET: XXXXXXXXXXXXXXXXXXXX
    $   THE_CITY_AUTH_URL: https://authentication.onthecity.org/authorization
                                                                             \
