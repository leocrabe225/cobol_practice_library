# Directories
SRC_FOLDER = srcs/
OBJECT_FOLDER = objects/

MAIN_SRC = $(SRC_FOLDER)blibrary.cbl
# Get all .cbl files from source directory
ALL_SRC = $(shell find $(SRC_FOLDER) -type f -name '*.cbl')
SRC = $(filter-out $(MAIN_SRC), $(ALL_SRC))

MAIN_PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(OBJECT_FOLDER)%.cob, $(MAIN_SRC))
# Compute precompiled .cob files in objects/ (e.g., srcs/foo.cbl -> objects/foo.cob)
PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(OBJECT_FOLDER)%.cob, $(SRC))

# Shared libraries (e.g., objects/foo.so)
LIBS = $(PRECOMPILED:.cob=.so)

# Final binary
BIN = blibrary

# Default rule
all: $(BIN)
	./$(BIN)

# Link all .cob files into one executable
$(BIN): $(MAIN_PRECOMPILED) $(PRECOMPILED)
	cobc -x -locesql $(MAIN_PRECOMPILED) $(PRECOMPILED) -o $(BIN) -I srcs/Copybooks

# Rule to build .cob files from .cbl files via ocesql
$(OBJECT_FOLDER)%.cob: $(SRC_FOLDER)%.cbl
	@mkdir -p $(dir $@)
	ocesql $< $@

# Build all shared libraries from .cob
libs: $(LIBS)

# Rule to build .so from .cob
$(OBJECT_FOLDER)%.so: $(OBJECT_FOLDER)%.cob
	cobc -m -locesql $< -o $@

# Clean all generated files
clean:
	rm -rf $(OBJECT_FOLDER) $(BIN)