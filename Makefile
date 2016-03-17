CC		:= clang
CFLAGS		+= -std=c99 -m64 -fPIC -O2 -fstack-protector -fvisibility=hidden -W -Wall -Wno-unused-parameter -Wno-unused-function -Wno-unused-label -Wpointer-arith -Wformat -Wreturn-type -Wsign-compare -Wmultichar -Winit-self -Wuninitialized -Wno-deprecated -Wformat-nonliteral -Wformat-security -Werror -pedantic
LDLIBS		:= -lpcre
FRAMEWORKS	:= -framework CoreFoundation
RM		:= rm -rf

SOURCES		= $(shell find src -iname '*.c' -print)
HEADERS		= $(shell find src -iname '*.h' -print)
OBJECTS		= $(patsubst src/%.c,obj/%.o,$(SOURCES))
TARGET		:= bin/thing

.PHONY:		all debug clean
.SECONDARY:	pre-build post-build main-build

all:		main-build
debug:		export DEBUGFLAGS := -DDEBUG -g
debug:		main-build

pre-build:	PCT := %
pre-build:
	@find src -type d -mindepth 1 -print | cut -b5- | xargs -I $(PCT) mkdir -p "obj/$(PCT)"

post-build:
	@:

main-build:	pre-build
	@$(MAKE) --no-print-directory $(TARGET)

obj/%.o:	src/%.c $(HEADERS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEBUGFLAGS) -o $@ -c $<

$(TARGET):	$(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LOADLIBES) $(LDLIBS) $(FRAMEWORKS)
	@$(MAKE) --no-print-directory post-build

clean:
	$(RM) bin/* obj/*
