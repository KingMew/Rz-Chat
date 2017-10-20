# Rz-Chat
Terminal-based client for the Residents.com chat (Sorry goatie)

Still in active development, but it *technically* works right now!

## Installation
You must have Ruby (obviously) and Bundler available on your system.

Run `bundle install` to install the gem dependencies, and you should be set!

## How to use
Run the executable `./chat.rb` in a terminal. You'll be prompted for your username and password for Rz chat. This works the same way as the standard web chat. If you type in a new username with no password, you'll log in as a lurker. Once your login has been confirmed, you'll be asked to repeat your username to save these login details for next time. You can do this to skip the login process next time, or just skip this to continue logging in manually.

Afterwards, you'll be brought to the chat screen. Press enter after typing a message to send it (duh). You can use the <kbd>F5</kbd> and <kbd>F6</kbd> keys to switch from Residents Chat to Chat Chat.

Configuration is saved in either `$HOME/.config/RzChat/config` or `%APPDATA%\RzChat\config` depending on environment. This configuration stores your username and password in plain text (I know things should be secure, but hey, if my super big IRC client does the same thing, I can too. Besides... it's just your Residents Web Chat credentials...). You can delete this file or blank it out in order to enable manual logins again.

If you miss the chat sound effects, you can do a little hacky thing to re-enable them. You can add a `beepcmd` property to this application's config file. The value of this property is a shell command that is executed whenever new messages arrive in either Residents or Chat chat. From there, you can add in an audio player command to play the chat's "pop" sound effect, or any other sound effect you'd like.
```
username = "blah"
password = "blah"
beepcmd = "mplayer ~/Documents/chatpop.mp3"
```
