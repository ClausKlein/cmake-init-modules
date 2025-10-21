# Standard stuff

.SUFFIXES:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
# MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
# MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

# CXX is a special variable in GNU Make. If not defined in the environment or Makefile,
# Make assigns it a default value, usually g++.
ifeq ($(origin CXX),default)
LLVM_PREFIX := $(shell brew --prefix llvm)
LLVM_PATH := $(shell realpath $(LLVM_PREFIX))
export CC := $(LLVM_PATH)/bin/clang
export CXX := $(LLVM_PATH)/bin/clang++
export CXXFLAGS := -stdlib=libc++
export LDFLAGS := -L$(LLVM_PATH)/lib/c++ -lc++abi -lc++
export GCOV="llvm-cov gcov"
endif

export hostSystemName=$(shell uname)

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check format test

all: .init clean # conan
	cmake --workflow --preset dev --fresh \
	  # XXX --log-level=VERBOSE
	# TODO(CK): gcovr -v

check: all
	-run-clang-tidy -p build/dev

.init: .CMakeUserPresets.json
	-pipx list
	-pipx ensurepath
	# TODO: jrsonnet --preserve-order CMakeUserPresets.jsonnet > CMakeUserPresets.json ||
	perl -p -e 's/<hostSystemName>/${hostSystemName}/g;' .CMakeUserPresets.json > CMakeUserPresets.json
	mkdir -p build/coverage/
	$(CXX) --version
	-$(CXX) -print-file-name=libc++.modules.json
	-$(CXX) -print-file-name=libstdc++.modules.json
	cmake --version
	ninja --version
	touch .init

conan: conanfile.py GNUmakefile
	conan profile detect -f
	conan install . -s build_type=$(BUILD_TYPE) -s compiler.cppstd=23 -b missing

clean:
	rm -rf build example/build

distclean: clean
	rm -rf conan stagedir .init CMakeUserPresets.json
	# XXX NO! git clean -xdf

format: distclean
	codespell -w
	git ls-files ::*.py | xargs black
	git ls-files ::*CMakeLists.txt ::*.cmake ::*.cmake.in | xargs gersemi -i
	git ls-files ::*.cxx ::*.cpp ::*.hpp ::*.cppm  ::*.json | xargs clang-format -i

# Anything we don't know how to build will use this rule.
# The command is a do-nothing command.
#
% :: ;
