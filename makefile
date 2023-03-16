# Generic Makefile for hello-mingw

# The name of the resulting executable.
# The .exe extension on Windows is silently
# ignored, but used anyway.
TARGET = hello-mingw


# Set to 1 to build verbosely.
V ?= 0

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


# List of object files to be linked to create the binary.
OBJS += $(TARGET).o


# General rule to create an object file from a .c file.
%.o: %.c
	$(vecho) "    $(CC)      $@"
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<


# General rule to create an object file from a .cpp file.
%.o: %.cpp
	$(vecho) "    $(CXX)     $@"
	$(Q)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<


# The default target.
.PHONY: all
all: $(TARGET)


# Rule to create the target file from the specified object and lib files.
$(TARGET): $(OBJS)
	$(vecho) "    Linking target $@"
	$(Q)$(CXX) -o $@ $(LDFLAGS) $^ $(LDLIBS)


# Rule to clean up and delete the compiled
# and intermediate files.
.PHONY: clean
clean:
	rm -f *.o $(TARGET)

