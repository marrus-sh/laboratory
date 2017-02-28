#  LABORATORY  #

A custom frontend for **Mastodon/Ardipithecus**.
Inspired by the original Mastodon frontend, but completely rewritten.

Read the [docs](docs) for more information.

##  Implementation Roadmap  ##

###  Features:

- [x]  Column layout
- [x]  Timeline columns
- [x]  Notifications columns
- [x]  "Getting Started" column
- [x]  "Not found" column
- [x]  Compose module
- [x]  Account module
- [x]  Column posts
- [x]  Column notifications
- [x]  Showing post relationships
- [x]  Compiled version
- [x]  Standalone functionality (?!)
- [x]  Unhosted version
- [ ]  Status module
- [ ]  Hiding posts behind messages
- [ ]  Media support
- [ ]  Sensitive content support
- [ ]  Post threads
- [ ]  Handling multiple reblogs of the same post (? is this a backend issue?)
- [ ]  Confirm? button
- [ ]  Error messages
- [ ]  Loading bar
- [ ]  "Default privacy"
- [ ]  Updating timelines and notifications
- [ ]  Loading more from timelines and notifications
- [ ]  Add "settings" button to profile card
- [ ]  Logging off
- [ ]  WebSockets support
- [ ]  Eliminate interfaces by using events and placing handlers on components (?? if possible)
- [ ]  Visually distinguish locked accounts
- [ ]  Simplified colour specification
- [ ]  Documentation!

###  API Support:

####  OAUTH.

- [x]  OAuth client registration
- [x]  OAuth authentication

####  GET.

- [x]  Getting accounts
- [x]  Getting account relationships
- [x]  Getting timelines
- [x]  Getting notifications
- [ ]  Getting individual posts
- [ ]  Getting a thread of posts
- [ ]  Getting reblogs/favourites for a post
- [ ]  Getting a user's follows
- [ ]  Getting the people following a user
- [ ]  Searching for content
- [ ]  Getting an account's blocks

####  POST.

- [ ]  Uploading media
- [ ]  Posting new statuses
- [ ]  Favouriting
- [ ]  Unfavouriting
- [ ]  Reblogging
- [ ]  Unreblogging
- [ ]  Following a user
- [ ]  Unfollowing a user
- [ ]  Blocking a user
- [ ]  Unblocking a user
- [ ]  Clearing notifications

####  DELETE.

- [ ]  Deleting a status
