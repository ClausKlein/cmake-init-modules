# Standard stuff

.SUFFIXES:

MAKEFLAGS+= --no-builtin-rules  # Disable the built-in implicit rules.
# MAKEFLAGS+= --warn-undefined-variables        # Warn when an undefined variable is referenced.
# MAKEFLAGS+= --include-dir=$(CURDIR)/conan     # Search DIRECTORY for included makefiles (*.mk).

export hostSystemName=$(shell uname)

ifeq (${hostSystemName},Darwin)
  export LLVM_PREFIX=$(shell brew --prefix llvm)
  export LLVM_DIR=$(shell realpath ${LLVM_PREFIX})
  export PATH:=${LLVM_DIR}/bin:${PATH}

  export CMAKE_CXX_STDLIB_MODULES_JSON=${LLVM_DIR}/lib/c++/libc++.modules.json
  export CXX=clang++
  export LDFLAGS=-L$(LLVM_DIR)/lib/c++ -lc++abi -lc++ # -lc++experimental
  export GCOV="llvm-cov gcov"

  ### TODO: to test g++-15:
  export GCC_PREFIX=$(shell brew --prefix gcc)
  export GCC_DIR=$(shell realpath ${GCC_PREFIX})

  # export CMAKE_CXX_STDLIB_MODULES_JSON=${GCC_DIR}/lib/gcc/current/libstdc++.modules.json
  # export CXX:=g++-15
  # export CXXFLAGS:=-stdlib=libstdc++
  # export GCOV="gcov"
else ifeq (${hostSystemName},Linux)
  # export LLVM_DIR=/usr/lib/llvm-20
  # export PATH:=${LLVM_DIR}/bin:${PATH}
  # export CXX=clang++-20
endif

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check test

all: .init # XXX clean # NO! conan
	cmake --workflow --preset dev
	# TODO(CK): gcovr -v

check: all
	-run-clang-tidy -p build/dev

.init: .CMakeUserPresets.json GNUmakefile
	-pipx ensurepath
	# TODO: jrsonnet --preserve-order CMakeUserPresets.jsonnet > CMakeUserPresets.json ||
	perl -p -e 's/<hostSystemName>/${hostSystemName}/g;' .CMakeUserPresets.json > CMakeUserPresets.json
	mkdir -p build/coverage/
	-$(CXX) --version
	-$(CXX) -print-file-name=libc++.modules.json
	-$(CXX) -print-file-name=libstdc++.modules.json
	cmake --version
	ninja --version
	cmake --preset dev --fresh --log-level=VERBOSE
	ln -fs build/dev/compile_commands.json .
	touch .init

conan: conanfile.py
	conan profile detect -f
	conan install . -s build_type=$(BUILD_TYPE) -s compiler.cppstd=23 -b missing

clean:
	rm -rf build example/build

distclean: clean
	rm -rf conan stagedir .init CMakeUserPresets.json tags
	find . -name '*~' -delete
	# XXX NO! git clean -xdf

GNUmakefile :: ;
*.txt :: ;
*.json :: ;

# Anything we don't know how to build will use this rule.
% ::
	ninja -C build/dev $(@)
