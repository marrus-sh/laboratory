#  LABORATORY  #

A custom frontend for **Mastodon/Ardipithecus**.
Inspired by the original Mastodon frontend, but completely rewritten.

Read the [docs](docs) for more information.

##  Implementation Roadmap  ##

###  Features:

- [x]  Column layout
- [x]  "Getting Started" column
- [x]  Compose module
- [x]  Account module
- [x]  Showing post relationships
- [ ]  Status module
- [ ]  Hiding posts behind messages
- [ ]  Media support
- [ ]  Sensitive content support
- [ ]  Post threads
- [ ]  Handling multiple reblogs of the same post
- [ ]  Standalone functionality (?!)

###  API Support:

####  GET.

- [x]  Getting accounts
- [x]  Getting account relationships
- [x]  Getting timelines
- [ ]  Getting notifications
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
- [ ]  Blocking a user
- [ ]  Unblocking a user
- [ ]  Clearing notifications
- [ ]  Following a remote user

####  DELETE.

- [ ]  Deleting a status
