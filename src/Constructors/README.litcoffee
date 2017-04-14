<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/README.litcoffee</code></p>

#  LABORATORY CONSTRUCTORS  #

 - - -

##  Description  ##

The data received from Laboratory API responses is processed and converted into one of several object types before it makes its way to users.
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
- [__Request__](Request.litcoffee)
- [__Rolodex__](Rolodex.litcoffee)
- [__Timeline__](Timeline.litcoffee)

###  API spoofing:

Most Laboratory constructors expect a Mastodon API response as their first argument.
If you find yourself needing to call them yourself (to dispatch your own `Post`s, for example), then you should feed them an object that matches what would be sent out by the Mastodon server.
See the [Mastodon API documentation](https://github.com/tootsuite/mastodon/blob/master/docs/Using-the-API/API.md) for details on what these objects look like.

 - - -

##  Implementation  ##

See specific constructor pages for details on their implementation.

>   __[Issue #6](https://github.com/marrus-sh/laboratory/issues/6) :__
>   Constructor getters may be re-written to use lazy-loading in the future.

>   __[Issue #9](https://github.com/marrus-sh/laboratory/issues/9) :__
>   Right now arrays and objects passed to constructors must originate in the same window as the constructor.
>   This requirement may be lifted in the future.

>   __[Issue #10](https://github.com/marrus-sh/laboratory/issues/10) :__
>   Right now constructors only require that they be called with a `this` that is an `instanceof` themselves, but this may change in the future.

>   __[Issue #11](https://github.com/marrus-sh/laboratory/issues/11) :__
>   As a matter of fact, the way `instanceof` works for Laboratory constructors may itself be modified at some future time.

>   __[Issue #62](https://github.com/marrus-sh/laboratory/issues/62) :__
>   Constructors may not support very recent additions to the Mastodon API.
