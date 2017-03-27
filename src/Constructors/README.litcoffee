_Laboratory_<br>
Source Code and Documentation<br>
API Version: _0.3.1_

#  LABORATORY CONSTRUCTORS  #

>   File location: `Constructors/README.litcoffee`

 - - -

##  Description  ##

The data received from Laboratory event responses is processed and converted into one of several object types before it makes its way to users.
This process is handled by __Laboratory constructors,__ which define the basic data types used when interacting with the API.
Many Laboratory constructors are also API modules; however, some are more "passive" and don't have events directly associated with them.

The Laboratory constructors are as follows:

- [__Application__](Application.litcoffee)
- [__Attachment__](Attachment.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Client__](Client.litcoffee)
- [__Enumeral__](Enumeral.litcoffee)
- [__Failure__](Failure.litcoffee)
- [__Post__](Post.litcoffee)
- [__Profile__](Profile.litcoffee)
- [__Rolodex__](Rolodex.litcoffee)
- [__Timeline__](Timeline.litcoffee)

###  API spoofing:

Most Laboratory constructors expect a Mastodon API response as their first argument.
If you find yourself needing to call them yourself (to dispatch your own `Post`s, for example), then you should feed them an object that matches what would be sent out by the Mastodon server.
See the [Mastodon API documentation](https://github.com/tootsuite/mastodon/blob/master/docs/Using-the-API/API.md) for details on what these objects look like.

 - - -

##  Implementation  ##

See specific constructor pages for details on their implementation.