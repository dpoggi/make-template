# make-template

Project template for using GNU make, optionally with some fun OS X things too. Please, please, please do not use this for anything that will be distributed - look to autotools, CMake, SCons, etc. Mostly for my own use, doing mostly nothing at all.

## `thing.c`

Decided that I wanted to leave an example of using both traditional POSIX libraries and OS X frameworks in this template, so this is an utterly useless program that does just that. That said, if you get bored and read it and you think my C sucks, open an issue, as long as the suckage is unrelated to the overall uselessness of the program itself.

## Caveats and Opinionated Stuff

Caveat emptor: changing any header file will rebuild the entire project. Also, I prefer to include headers from the project itself using quotes. If you're an angle bracket fan, add `CPPFLAGS += -Isrc` to the top of `Makefile`.

## Copyright

Copyright (C) 2016 Dan Poggi. MIT License, see LICENSE for details.
