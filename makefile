# Generic Makefile for hello-mingw


# The name of the resulting executable.
TARGET = hello-mingw

# Set to 1 to build verbosely
V ?= 0


# Set to 0 to build with mbglib extensions
USE_MBGLIB ?= 1


# The lines below make the build output non-verbose by default.
# Call make with parameter "V=1" to get verbose output.
ifeq ("$(V)","1")
  Q :=
  QM :=
  vecho = @true
else
  Q := @
  QM := -s
  vecho = @echo
endif


# CPPFLAGS are used both to compile .c and .cpp sources.

ifdef DEBUG
  CPPFLAGS += -DDEBUG=$(DEBUG)
  CPPFLAGS += -g2
else
  CPPFLAGS += -O2
endif

CPPFLAGS += -Wall

# Avoid dependencies on MSYS2/Mingw DLLs.
LDFLAGS += -static


OBJS += $(TARGET).o

ifneq ("$(USE_MBGLIB)","0")
  MBGLIB = mbglib/common

  CPPFLAGS += -I$(MBGLIB)
  VPATH += $(MBGLIB)

  # Specify object files tfrom
  # OBJS += mbgerror.o
endif


.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJS)
	$(vecho) "    Linking $@"
	$(Q)$(CXX) -o $@ $(LDFLAGS) $^ $(LDLIBS)


.PHONY: clean
clean:
	rm -f *.o $(TARGET)


%.o: %.c
	$(vecho) "    $(CC)       $@"
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<


%.o: %.cpp
	$(vecho) "    $(CXX)      $@"
	$(Q)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

