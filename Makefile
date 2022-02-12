# -*- Makefile -*- for glfw

.SECONDEXPANSION:
.SUFFIXES:

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
        QUIET          = @
        QUIET_CC       = @echo '   ' CC $<;
        QUIET_AR       = @echo '   ' AR $@;
        QUIET_RANLIB   = @echo '   ' RANLIB $@;
        QUIET_INSTALL  = @echo '   ' INSTALL $<;
        export V
endif
endif

LIB      = libglfw.a
AR      ?= ar
ARFLAGS ?= rc
CC      ?= gcc
RANLIB  ?= ranlib
RM      ?= rm -f

BUILD_DIR := obj
BUILD_ID  ?= default-build-id
OBJ_DIR   := $(BUILD_DIR)/$(BUILD_ID)

ifeq (,$(BUILD_ID))
$(error BUILD_ID cannot be an empty string)
endif

uname_S := $(shell uname -s)

prefix ?= /usr/local
libdir := $(prefix)/lib
includedir := $(prefix)/include/GLFW

CFLAGS += -I$(includedir)

ifeq ($(uname_S),Darwin)
    CFLAGS += -D_GLFW_COCOA
endif
ifeq ($(uname_S),Linux)
    CFLAGS += -D_GLFW_X11
endif

HEADERS = \
	include/GLFW/glfw3.h \
	include/GLFW/glfw3native.h \

SOURCES = \
	src/context.c \
	src/egl_context.c \
	src/init.c \
	src/input.c \
	src/monitor.c \
	src/null_init.c \
	src/null_joystick.c \
	src/null_monitor.c \
	src/null_window.c \
	src/osmesa_context.c \
	src/platform.c \
	src/posix_module.c \
	src/posix_thread.c \
	src/vulkan.c \
	src/window.c \

ifeq ($(uname_S),Darwin)
    SOURCES += \
		src/cocoa_time.c \
		src/*.m \

endif
ifeq ($(uname_S),Linux)
    SOURCES += \
		src/glx_context.c \
		src/linux_joystick.c \
		src/posix_time.c \
		src/x11*.c \
		src/xkb_unicode.c \

endif

SOURCES := $(wildcard $(SOURCES))

HEADERS_INST := $(patsubst include/GLFW/%,$(includedir)/%,$(HEADERS))
OBJECTS := $(filter %.o,$(patsubst %.c,$(OBJ_DIR)/%.o,$(SOURCES)))
OBJECTS += $(filter %.o,$(patsubst %.m,$(OBJ_DIR)/%.o,$(SOURCES)))

CFLAGS ?= -O2

.PHONY: install

all: $(OBJ_DIR)/$(LIB)

$(includedir)/%.h: include/GLFW/%.h
	-@if [ ! -d $(includedir)  ]; then mkdir -p $(includedir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

$(libdir)/%.a: $(OBJ_DIR)/%.a
	-@if [ ! -d $(libdir)  ]; then mkdir -p $(libdir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

install: $(HEADERS_INST) $(libdir)/$(LIB)

clean:
	$(RM) -r $(OBJ_DIR)

distclean: clean
	$(RM) -r $(BUILD_DIR)

$(OBJ_DIR)/$(LIB): $(OBJECTS)
	$(QUIET_AR)$(AR) $(ARFLAGS) $@ $^
	$(QUIET_RANLIB)$(RANLIB) $@

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR)/.cflags | $$(@D)/.
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<

$(OBJ_DIR)/%.o: %.m $(OBJ_DIR)/.cflags | $$(@D)/.
	$(QUIET_CC)$(CC) $(CFLAGS) $(OBJCFLAGS) -o $@ -c $<

.PRECIOUS: $(OBJ_DIR)/. $(OBJ_DIR)%/.

$(OBJ_DIR)/.:
	$(QUIET)mkdir -p $@

$(OBJ_DIR)%/.:
	$(QUIET)mkdir -p $@

TRACK_CFLAGS = $(subst ','\'',$(CC) $(CFLAGS))

$(OBJ_DIR)/.cflags: .force-cflags | $$(@D)/.
	@FLAGS='$(TRACK_CFLAGS)'; \
    if test x"$$FLAGS" != x"`cat $(OBJ_DIR)/.cflags 2>/dev/null`" ; then \
        echo "    * rebuilding glfw: new build flags or prefix"; \
        echo "$$FLAGS" > $(OBJ_DIR)/.cflags; \
    fi

.PHONY: .force-cflags
