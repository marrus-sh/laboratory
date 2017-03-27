#  CONTRIBUTING  #

##  Branches and Pull Requests  ##

Development for Laboratory takes place on the `development-x.y.z` branch, where `x.y.z` is the version number of the currently-being-developed version.
Any pull requests should be made to this branch, and not to `master`.
This allows specific versioned releases to be well-documented.

##  Issues  ##

Laboratory employs a number of issue labels, which are summarized below:

- __bug :__ Laboratory differs from its specification or what might be reasonably expected
- __depreciation :__ An aspect of Laboratory should be removed
- __documentation :__ This issue relates to the Laboratory specification/documentation in addition to or instead of its implementation
- __duplicate :__ This issue has already been reported before
- __enhancement :__ A new feature should be added to Laboratory
- __low-priority :__ This issue might not be fixed for a while
- __polish :__ This issue improves an existing aspect of how Laboratory operates without changing which features are offered
- __question :__ It is unclear whether this issue needs to be acted upon
- __wontfix :__ This issue won't be acted upon

When creating new issues, please describe thoroughly the problem or, in the case of feature-requests, provide scenarios where the proposed fix would be beneficial.
Providing an extensive technical solution isn't necessary in the case of most issues, but make an effort to help readers understand the problem at hand.

##  Contribution Guidelines  ##

If you're planning on submitting a Pull Request to Laboratory, here are some tips to help you be successful:

###  Document your code:

Laboratory is written in Literate CoffeeScript, so be literate about it!
Code should be written in a manner that flows well narratively, and written documentation explaining what it does in plain English should accompany any code.
It should be possible to understand *what* a file does by only reading the Markdown; the code exists to describe to a computer *how*.

###  Be mindful of data mutability:

If a property shouldn't be overwritten, consider defining it with `Object.definePropery()`.
If an object should be considered immutable, use `Object.freeze()`.
Don't directly modify arguments passed in from outside sources, and be careful when evaluating them in case they don't respond like you expect.

###  Be concise and elegant:

CoffeeScript is a very powerful language for writing code that is elegant and easy-to-read.
Take advantage of this!
Having text explanations above and below doesn't excuse messy code.
That said, don't be afraid to sacrifice some readability for efficiency or conciseness if what you're doing is well-documented.

###  Format your code correctly:

Laboratory follows the conventions set forward in the [Laboratory Style Guide](https://github.com/marrus-sh/laboratory-style).
Try to follow this guide as closely as possible.
