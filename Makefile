MAKEDEPEND	?= makedepend
INSTALL		?= install

PKGS		:= libpq
CPPFLAGS	+= $(shell pkg-config --cflags-only-I $(PKGS) 2>/dev/null)
CFLAGS		+= -std=gnu99 -m64 -fPIC -fstack-protector -fvisibility=hidden -W -Wall -Wno-unused-parameter -Wno-unused-function -Wno-unused-label -Wpointer-arith -Wformat -Wreturn-type -Wsign-compare -Wmultichar -Winit-self -Wuninitialized -Wno-deprecated -Wformat-nonliteral -Wformat-security -Werror -pedantic
LDFLAGS		+= $(shell pkg-config --libs-only-L $(PKGS) 2>/dev/null)
LDLIBS		:= $(shell pkg-config --libs-only-l $(PKGS) 2>/dev/null)

SOURCES		:= $(wildcard *.c)
OBJECTS		:= $(SOURCES:%.c=%.o)
TARGET		:= pg_escape

PREFIX		?= /usr/local

.PHONY:		all debug clean depend install help

all:		CFLAGS += -O2
all:		$(TARGET)

debug:		CFLAGS += -O0 -g
debug:		$(TARGET)

$(TARGET):	$(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

%.o:		%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

clean:
	$(RM) $(TARGET) $(OBJECTS)

depend:
	$(MAKEDEPEND) -- $(CPPFLAGS) $(CFLAGS) -- $(SOURCES) 2>/dev/null

install:	OWNER := $(shell id -un)
install:	GROUP := $(shell id -gn)
install:	all
	$(INSTALL) -p -o $(OWNER) -g $(GROUP) -m 0755 $(TARGET) $(PREFIX)/bin

help:
	@echo "$(TARGET) Makefile"
	@echo
	@echo "Usage:"
	@echo "    make[ all]           Build $(TARGET)"
	@echo "    make debug           Build $(TARGET) with debug symbols"
	@echo "    make clean           Remove build artifacts"
	@echo "    make depend          Bring dependencies up-to-date"
	@echo
	@echo "    make install         Install $(TARGET) to PREFIX [$(PREFIX)]"
	@echo
	@echo "    make help            Display this message"

# DO NOT DELETE THIS LINE -- make depend depends on it.
