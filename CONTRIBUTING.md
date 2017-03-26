##  CONTRIBUTING  ##

##  Guidelines  ##

Want to contribute to Laboratory?
That's great!
Feel free to submit a Pull Request through Github.
However, here are some guidelines to help your work be successful:

###  Document your code:

Laboratory is written in Literate CoffeeScript, so be literate about it!
Code should be written in a manner that flows well narratively, and written documentation explaining what it does in plain English should accompany any code.
It should be possible to understand *what* a file does by only reading the Markdown; the code exists to describe to a computer *how*.

###  Be mindful of data mutability:

If a property shouldn't be overwritten, you should define it with `Object.definePropery()`.
If an object should be considered immutable, use `Object.freeze()`.
You will find that most of the time when defining objects in our code one or both of these functions will come into play.

###  Be concise and elegant:

CoffeeScript is a very powerful language for writing code that is elegant and easy-to-read.
Take advantage of this!
Having text explanations above and below doesn't excuse messy code.

##  Style Guide  ##

This section describes the style conventions you are likely to encounter when reading Laboratory source.

###  Markdown:

Except where otherwise noted, prose should attempt to follow the Chicago Manual of Style.
Em dashes with no surrounding spaces are used for parantheticals.
Abbreviations are written either all-lowercase or all-uppercase, with the former preferred except at the beginning of sentences, and no trailing period (eg: url, id, html).
The following sections provide more information on Markdown-specific conventions.

####  Headings.

Headings should always be indicated using hash marks, as shown in the code below.
Place two spaces between the hash marks and the heading text.

```markdown
    #  THIS IS A TITLE  #
    ##  This Is A H2 Heading  ##
    ###  This is a H3 heading:
    ####  This is a H4 heading.
    #####  THIS IS A H5 HEADING
    ######  this is a h6 heading
```

Headings should be preceded and followed by a blank line, unless the heading is the first or line in the file (in which case a blank line beforehand is unnecessary).

####  Paragraphs.

Markdown paragraphs are written with one sentence per line.
This helps document which sentences have changed when looking at git diffs.
Don't break a sentence across multiple lines; similarly, don't put more than one sentence on the same line.

####  Lists.

Markdown lists come in two forms: expanded and condensed.
Condensed lists look like this:

- This is an unnumbered list item
    - This is a sub-item
- Note that there is a space before and after the list, but not in-between items
- Never use a condensed list for something more than one sentence long

1.  This is a numbered list
2.  Note that there are two spaces before each item's contents

Expanded lists look like this:

 -  This is an expanded list.
    Use this for lists that contain multiple sentences.

 -  You'll notice that there is a blank line between each list item.
    This renders each list as a paragraph.

1.  Numbered lists can also be rendered in an expanded form.

2.  Even though Markdown doesn't require it, try to keep numbering accurate for numbered lists.

####  Code blocks.

Code blocks in source code files should always be placed inside blockquotes using GFM fenced code syntax, like this:

>   ```coffeescript
>       -> "Here is some CoffeeScript code."
>   ```

Literate CoffeeScript will interpret any indented lines as source code, so encapsulating documentation code in blockquotes helps keep everything nicely separated.

#####  LANGUAGES

Laboratory is written in CoffeeScript, but documentation code should be written instead using plain JavaScript.
Knowledge of CoffeeScript should not be a prerequisite for interfacing with the Laboratory engine.

####  Issues and notes.

If you want to reference an open issue, or make a note, the syntax for this is as follows:

>   __Note :__
>   This is a note.

Note the space between the colon and the word "Note".
Again, each sentence should be on its own line.
If the issue has a GitHub link, you might include that:

>   __[Issue #XX](https://github.com/marrus-sh/laboratory/issues/XX) :__
>   Here is a comment regarding that issue

Following this syhtax will make finding references to notes and issues easy when searching through pages of source.

####  Other considerations.

If you need to make a line-break, **always** use a `<br>` element.
**Never** use blank spaces at the end of a line to indicate a manual break.

Two asterisks are used for **important content**, while one asterisk is used for *emphasis*.
Use underscores if you need __boldfaced__ or _italicized_ text without these semantics.

References to code should use `backticks`.
HTML elements should be lowercase and surrounded by angle brackets, like `<this>`.
You may optionally specify attributes as well; `<div class="so">` refers to `<div>` elements with the class `so`.
Functions and constructors should be followed by parentheses, like `this()`.
However, when referring to instances and prototypes, no parentheses are used; for example, one might say `something` is an instance of `ThisOne` even though it was created using the constructor `ThisOne()`.

###  CoffeeScript:

####  Variable naming.

Variables and functions are named using `camelCase`, with the first letter lowercase.
Functions which are meant to serve as constructors and objects which act as modules are named using `CamelCase`, with the first letter capitalized.
Enumerals are named using `UPPERCASE_LETTERS_WITH_UNDERSCORES`.

The Mastodon API frequently makes use of `lowercase_letters_with_underscores` for its parameter names, although we rarely have to deal with this directly.
Event types should follow the syntax `LaboratoryModuleEventName`, where this is a reference to an event dispatched by `Laboratory.Module.Event.EventName`.

####  Spacing.

Lines should be indented using 4 spaces.
This is very important as it keeps code readable even when it is broken up by long paragraphs of text documentation.

####  Strings.

Strings are double-quoted where possible.
Generally speaking, try to avoid performing substitutions in stings using the `"#{}"` syntax; instead concatenate multiple strings with your code using `+`.

####  Functions.

Generally speaking, if you can avoid using parentheses when calling a function, do.
Include parentheses only if the code becomes very ambiguous to readers otherwise.

####  Objects.

Only wrap an object in `{}` if you are declaring it all on one line; using the multi-line YAML-like syntax is greatly preffered.
This includes in function calls—you don't need parentheses around the object either in this case.

####  Constructors.

Constructors should be written as functions with separate prototypes.
**Do not use CoffeeScript's `class` syntax to write constructors.**
Constructors and their prototypes should always be frozen using `Object.freeze` to prevent them from being modified after creation.

####  Local variables and closure.

Because our CoffeeScript files are concatenated into a single file before compilation, local variables from one file are also available in another.
In general, **you should not use local variables**, and whenever you need to declare a variable outside of the scope of a function you should encapsulate it in a `do ->` statement.
The exceptions to this are API or constructor functions, and the Laboratory `Store`.

####  Postfix forms.

Generally speaking, you should use the postfix forms of `if`, `unless`, `for`, `while`, etc. where possible.