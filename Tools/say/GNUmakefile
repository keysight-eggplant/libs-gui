# ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
# Committed by: Frank Le Grand 
# Commit ID: 4b27157a46ce2a51d886db45ac5ccfec1b00c1d0 
# Date: 2013-08-09 14:24:48 +0000 
# ========== End of Keysight Technologies Notice ========== 
ETOILE_CORE_MODULE = YES

include $(GNUSTEP_MAKEFILES)/common.make

GSSPEECHENGINE = Flite

VERSION = 0.1
TOOL_NAME = say 

say_LANGUAGES = English

say_OBJC_FILES = \
	say.m

# Add include/lib dirs for currently built headers and libs.
say_INCLUDE_DIRS += -I../../Headers -I../../Headers/Additions
say_LIB_DIRS += -L../../Source/$(GNUSTEP_OBJ_DIR) \
	-L/usr/local/lib 

#say_OBJCFLAGS += -std=c99 -g -Werror
say_TOOL_LIBS += -lgnustep-gui

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/tool.make
