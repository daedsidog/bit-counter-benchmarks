GCC = gcc
CLANG = clang
GCC_OPTFLAGS = -O3 -Ofast -flto -march=native -ffast-math -funroll-loops -ftree-vectorize -fpredictive-commoning
CLANG_OPTFLAGS = -O3 -Ofast -flto -march=native -ffast-math -funroll-loops -fvectorize -ftree-vectorize
BIN_DIR = bin
GCC_ECL_BIN = gcc-ecl-plb
GCC_ECL_INLINE_C_BIN = gcc-ecl-inline-c-plb
OPT_GCC_ECL_BIN = opt-gcc-ecl-plb
OPT_GCC_ECL_INLINE_C_BIN = opt-gcc-ecl-inline-c-plb
CLANG_ECL_BIN = clang-ecl-plb
CLANG_ECL_INLINE_C_BIN = clang-ecl-inline-c-plb
OPT_CLANG_ECL_BIN = opt-clang-ecl-plb
OPT_CLANG_ECL_INLINE_C_BIN = opt-clang-ecl-inline-c-plb
GCC_ECL_CMD = " \
(progn \
  (setf c::*cc* \"$(GCC)\") \
  (compile-file \"../src/lisp/plb.lisp\" :system-p t) \
  (c::build-program \"$(GCC_ECL_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
GCC_ECL_INLINE_C_CMD = " \
(progn \
  (setf c::*cc* \"$(GCC)\") \
  (compile-file \"../src/lisp/inline-c-plb.lisp\" :system-p t) \
  (c::build-program \"$(GCC_ECL_INLINE_C_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/inline-c-plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
OPT_GCC_ECL_CMD = " \
(progn \
  (setf c::*safety* 0) \
  (setf c::*cc* \"$(GCC)\") \
  (setf c::*cc-optimize* \"$(GCC_OPTFLAGS)\") \
  (compile-file \"../src/lisp/plb.lisp\" :system-p t) \
  (c::build-program \"$(OPT_GCC_ECL_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
OPT_GCC_ECL_INLINE_C_CMD = " \
(progn \
  (setf c::*safety* 0) \
  (setf c::*cc* \"$(GCC)\") \
  (setf c::*cc-optimize* \"$(GCC_OPTFLAGS)\") \
  (compile-file \"../src/lisp/inline-c-plb.lisp\" :system-p t) \
  (c::build-program \"$(OPT_GCC_ECL_INLINE_C_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/inline-c-plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
CLANG_ECL_CMD = " \
(progn \
  (setf c::*cc* \"$(CLANG)\") \
  (compile-file \"../src/lisp/plb.lisp\" :system-p t) \
  (c::build-program \"$(CLANG_ECL_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
CLANG_ECL_INLINE_C_CMD = " \
(progn \
  (setf c::*cc* \"$(CLANG)\") \
  (compile-file \"../src/lisp/inline-c-plb.lisp\" :system-p t) \
  (c::build-program \"$(CLANG_ECL_INLINE_C_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/inline-c-plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
OPT_CLANG_ECL_CMD = " \
(progn \
  (setf c::*safety* 0) \
  (setf c::*cc* \"$(CLANG)\") \
  (setf c::*cc-optimize* \"$(CLANG_OPTFLAGS)\") \
  (compile-file \"../src/lisp/plb.lisp\" :system-p t) \
  (c::build-program \"$(OPT_CLANG_ECL_BIN)\" \
                   :lisp-files (list (compile-file-pathname \"../src/lisp/plb.lisp\" :type :object)) \
                   :epilogue-code '(si::quit)) \
  (quit))"
OPT_CLANG_ECL_INLINE_C_CMD = " \
(progn \
  (setf c::*safety* 0) \
  (setf c::*cc* \"$(CLANG)\") \
  (setf c::*cc-optimize* \"$(CLANG_OPTFLAGS)\") \
  (compile-file \"../src/lisp/inline-c-plb.lisp\" :system-p t) \
  (c::build-program \"$(OPT_CLANG_ECL_INLINE_C_BIN)\" \
                    :lisp-files (list (compile-file-pathname \"../src/lisp/inline-c-plb.lisp\" :type :object)) \
                    :epilogue-code '(si::quit)) \
  (quit))"
CLEAN_ECL_OBJECTS = rm src/lisp/*.o
JAVA = javac
RUSTC = rustc
RUST_FLAGS = -C opt-level=3 -C lto -C codegen-units=1 -C target-cpu=native

all: | $(BIN_DIR) gcc opt-gcc clang opt-clang sbcl all-gcc-ecl all-clang-ecl java rust

$(BIN_DIR):
	mkdir -p $@

gcc: $(BIN_DIR) src/c/plb.c
	$(GCC) src/c/plb.c -o $(BIN_DIR)/gcc-plb

opt-gcc: $(BIN_DIR) src/c/plb.c
	$(GCC) $(GCC_OPTFLAGS) src/c/plb.c -o $(BIN_DIR)/opt-gcc-plb

clang: $(BIN_DIR) src/c/plb.c
	$(CLANG) src/c/plb.c -o $(BIN_DIR)/clang-plb

opt-clang: $(BIN_DIR) src/c/plb.c
	$(CLANG) $(CLANG_OPTFLAGS) src/c/plb.c -o $(BIN_DIR)/opt-clang-plb

sbcl: $(BIN_DIR) src/lisp/plb.lisp
	sbcl --load src/lisp/plb.lisp \
	     --eval "(save-lisp-and-die \"$(BIN_DIR)/sbcl-plb\" :toplevel #'main :executable t)"

all-clang-ecl: clang-ecl clang-ecl-inline-c opt-clang-ecl opt-clang-ecl-inline-c

all-gcc-ecl: gcc-ecl gcc-ecl-inline-c opt-gcc-ecl opt-gcc-ecl-inline-c

gcc-ecl: $(BIN_DIR) src/lisp/plb.lisp
	cd $(BIN_DIR) && ecl --eval $(GCC_ECL_CMD)
	$(CLEAN_ECL_OBJECTS)

gcc-ecl-inline-c: $(BIN_DIR) src/lisp/inline-c-plb.lisp
	cd $(BIN_DIR) && ecl --eval $(GCC_ECL_INLINE_C_CMD)
	$(CLEAN_ECL_OBJECTS)

opt-gcc-ecl: $(BIN_DIR) src/lisp/plb.lisp
	cd $(BIN_DIR) && ecl --eval $(OPT_GCC_ECL_CMD)
	$(CLEAN_ECL_OBJECTS)

opt-gcc-ecl-inline-c: $(BIN_DIR) src/lisp/inline-c-plb.lisp
	cd $(BIN_DIR) && ecl --eval $(OPT_GCC_ECL_INLINE_C_CMD)
	$(CLEAN_ECL_OBJECTS)

clang-ecl: $(BIN_DIR) src/lisp/plb.lisp
	cd $(BIN_DIR) && ecl --eval $(CLANG_ECL_CMD)
	$(CLEAN_ECL_OBJECTS)

clang-ecl-inline-c: $(BIN_DIR) src/lisp/inline-c-plb.lisp
	cd $(BIN_DIR) && ecl --eval $(CLANG_ECL_INLINE_C_CMD)
	$(CLEAN_ECL_OBJECTS)

opt-clang-ecl: $(BIN_DIR) src/lisp/plb.lisp
	cd $(BIN_DIR) && ecl --eval $(OPT_CLANG_ECL_CMD)
	$(CLEAN_ECL_OBJECTS)

opt-clang-ecl-inline-c: $(BIN_DIR) src/lisp/inline-c-plb.lisp
	cd $(BIN_DIR) && ecl --eval $(OPT_CLANG_ECL_INLINE_C_CMD)
	$(CLEAN_ECL_OBJECTS)

java: $(BIN_DIR) src/java/plb.java
	$(JAVA) -d $(BIN_DIR) src/java/plb.java

rust: $(BIN_DIR) src/rust/plb.rs
	$(RUSTC) $(RUST_FLAGS) src/rust/plb.rs -o $(BIN_DIR)/rust-plb

clean:
	rm -rf $(BIN_DIR)/*
