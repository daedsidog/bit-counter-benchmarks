GCC = gcc
CLANG = clang
CFLAGS = -O3
BIN_DIR = bin

LISP_TARGET = main
ECL_INLINE_C = "(progn \
                  (setf c::*cc* \"clang\") \
                  (setf c::*cc-optimize* \"-O3\") \
                  (compile-file \"../src/lisp/inline-c-plb.lisp\" :system-p t) \
                  (c::build-program \"inline-c-ecl-plb\" \
		                    :lisp-files (list (compile-file-pathname \"../src/lisp/inline-c-plb.lisp\" :type :object)) \
		                    :epilogue-code '(si::quit)) \
                  (quit))"
ECL_NO_INLINE_C = "(progn \
                     (setf c::*cc* \"clang\") \
                     (setf c::*cc-optimize* \"-O3\") \
                     (compile-file \"../src/lisp/plb.lisp\" :system-p t) \
                     (c::build-program \"ecl-plb\" \
	   	                   :lisp-files (list (compile-file-pathname \"../src/lisp/plb.lisp\" :type :object)) \
	                       :epilogue-code '(si::quit)) \
                     (quit))"

CLEAN_ECL_OBJECTS = rm src/lisp/*.o

JAVA = javac

RUSTC = rustc
RUST_FLAGS = -C opt-level=3

all: | $(BIN_DIR) gcc clang sbcl ecl inline-c-ecl java rust

$(BIN_DIR):
	mkdir -p $@

gcc: $(BIN_DIR) src/c/plb.c
	$(GCC) $(CFLAGS) src/c/plb.c -o $(BIN_DIR)/gcc-plb

clang: $(BIN_DIR) src/c/plb.c
	$(CLANG) $(CFLAGS) src/c/plb.c -o $(BIN_DIR)/clang-plb

sbcl: $(BIN_DIR) src/lisp/plb.lisp
	sbcl --load src/lisp/plb.lisp \
	     --eval "(save-lisp-and-die \"$(BIN_DIR)/sbcl-plb\" :toplevel #'$(LISP_TARGET) :executable t)"

ecl: $(BIN_DIR) src/lisp/plb.lisp
	cd $(BIN_DIR) && ecl --eval $(ECL_NO_INLINE_C)
	$(CLEAN_ECL_OBJECTS)

inline-c-ecl: $(BIN_DIR) src/lisp/inline-c-plb.lisp
	cd $(BIN_DIR) && ecl --eval $(ECL_INLINE_C)
	$(CLEAN_ECL_OBJECTS)

java: $(BIN_DIR) src/java/plb.java
	$(JAVA) -d $(BIN_DIR) src/java/plb.java

rust: $(BIN_DIR) src/rust/plb.rs
	$(RUSTC) $(RUST_FLAGS) src/rust/plb.rs -o $(BIN_DIR)/rust-plb

clean:
	rm -rf $(BIN_DIR)/*
