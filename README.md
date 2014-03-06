# The City Example Internal Plugin

Example Test App for The City

This is a Rails app that can be used as a plugin to The City.  It does the basic data decrypt and displays the information in various formats.  It also makes an API call to the authentication service to retrieves additional user data.

In order to get this sample to run, you will need to configure a couple of environment variables:

    THE_CITY_APP_SECRET=XXXXXXXXXXXXX
    THE_CITY_AUTH_URL=https://authentication.onthecity.org/authorization

Alternately, you can specify a YAML file located at:  /config/thecity.yml, that has the following format:

    production:
      THE_CITY_APP_SECRET: XXXXXXXXXXXXXXXXXXXX
      THE_CITY_AUTH_URL: https://authentication.onthecity.org/authorization
                                                                             \

## Safari and Cookies

There is an issue with the Safari browser and plugins in iFrames.  Safari does not allow Third Party Cookies by default, so any attempt to set a cookie (like for cookie based sessions) will fail.
This example plugin includes a work around for this, which takes a Safari user through this flow:

1.  Safari user opens plugin in iFrame
2.  User is presented with message that asks them to "Click Here"
3.  User clicks, a NEW tab is opened
4.  A permanent cookie is set by new window
5.  New window closes itself and refreshes iFrame
6.  Cookies can now be set, and normal output displayed

In order to enable this scenario in the plugin, pass a parameter of

    cookies=true

to the end of URL string you are using to call the plugin.  Otherwise, it doesn't attempt to set any cookies.  Since the cookie is permanent, the user will not have to do this again, even if they close and reopen their browser.  They will if they completely clear their cookies.