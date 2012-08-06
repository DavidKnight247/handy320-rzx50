#
# Unified Makefile for Handy/SDL Portable Lynx Emulator
#
# by James L. Hammons
#
# This software is licensed under the GPL v2 or any later version. Set the
# file GPL.TXT for details. ;-)
#

# NOTE: zlib and OpenGL libs are a dependency, but are not checked for.

# Figure out which system we're compiling for, and set the appropriate variables

OSTYPE=msys

ifeq "$(OSTYPE)" "msys"	
EXESUFFIX  = .exe
MSG        = Win32 on MinGW

CC         = gcc
LD         = gcc
else
ifeq "$(OSTYPE)" "dingux"
EXESUFFIX  = .dge
MSG = Dingux

CC = mipsel-linux-uclibc-gcc
LD = mipsel-linux-uclibc-gcc
endif
endif

TARGET     = handy_sdl

# Note that we use optimization level 2 instead of 3--3 doesn't seem to gain much over 2
CFLAGS   = -DDINGUX -MMD -Wall -O2 -Wno-switch -DANSI_GCC -DSDL_PATCH -ffast-math -fomit-frame-pointer 
CPPFLAGS = -DDINGUX -MMD -Wall -O2 -Wno-switch -Wno-non-virtual-dtor -DANSI_GCC -DSDL_PATCH -ffast-math -fomit-frame-pointer -g 

ifeq "$(OSTYPE)" "msys"	
LDFLAGS = -mconsole

#LIBS = -lSDL -lSDLmain -lmingw32 -lstdc++ -lz 
LIBS = -static -lstdc++ -Wl,-Bdynamic -lSDL -lSDLmain -lmingw32 -lz
else
ifeq "$(OSTYPE)" "dingux"
LDFLAGS = 
LIBS = -static -lstdc++ -Wl,-Bdynamic -lSDL -lz
endif
endif


INCS = -I./src -I./src/handy-0.95 -I./src/sdlemu

OBJS = \
		obj/cart.o \
		obj/memmap.o \
		obj/mikie.o \
		obj/ram.o \
		obj/rom.o \
		obj/susie.o \
		obj/system.o \
		obj/errorhandler.o \
		obj/unzip.o \
		obj/sdlemu_filter.o \
		obj/sdlemu_video.o \
		obj/handy_sdl_main.o \
		obj/handy_sdl_handling.o \
		obj/handy_sdl_graphics.o \
		obj/handy_sdl_sound.o

all: obj $(TARGET)$(EXESUFFIX)
	@echo "*** Looks like it compiled OK... Give it a whirl!"

clean:
	@echo -n "*** Cleaning out the garbage..."
	@rm -rf obj
	@rm -f ./$(TARGET)$(EXESUFFIX)
	@echo done!

obj:
	@mkdir obj

obj/%.o: src/handy-0.95/%.c
	@echo "*** Compiling $<..."
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/handy-0.95/%.cpp
	@echo "*** Compiling $<..."
	$(CC) $(CPPFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/%.c
	@echo "*** Compiling $<..."
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/%.cpp
	@echo "*** Compiling $<..."
	$(CC) $(CPPFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/sdlemu/%.c
	@echo "*** Compiling $<..."
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/sdlemu/%.cpp
	@echo "*** Compiling $<..."
	$(CC) $(CPPFLAGS) $(INCS) -c $< -o $@

obj/%.o: src/zlib-113/%.c
	@echo "*** Compiling $<..."
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@
	
$(TARGET)$(EXESUFFIX): $(OBJS)
	@echo "*** Linking it all together..."
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
#	strip --strip-all vj$(EXESUFFIX)
#	upx -9 vj$(EXESUFFIX)

# Pull in dependencies autogenerated by gcc's -MMD switch
# The "-" in front is there just in case they haven't been created yet

-include obj/*.d

