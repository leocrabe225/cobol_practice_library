# Directories
SRC_FOLDER = srcs/
OBJECT_FOLDER = objects/

# Get all .cbl files from source directory
SRC = $(wildcard $(SRC_FOLDER)*.cbl)

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
$(BIN): $(PRECOMPILED)
	cobc -x -locesql $(PRECOMPILED) -o $(BIN) -I srcs/Copybooks

# Rule to build .cob files from .cbl files via ocesql
$(OBJECT_FOLDER)%.cob: $(SRC_FOLDER)%.cbl
	@mkdir -p $(OBJECT_FOLDER)
	ocesql $< $@

# Build all shared libraries from .cob
libs: $(LIBS)

# Rule to build .so from .cob
$(OBJECT_FOLDER)%.so: $(OBJECT_FOLDER)%.cob
	cobc -m -locesql $< -o $@

# Clean all generated files
clean:
	rm -f $(OBJECT_FOLDER)*.cob $(OBJECT_FOLDER)*.so $(BIN)