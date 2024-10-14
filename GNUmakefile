# Standard stuff

.SUFFIXES:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
# MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
# MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

# export CC=gcc-14
# export CXX=g++-14
export CC?=clang-19
export CXX?=$(shell type -f clang++)
export CMAKE_EXPORT_COMPILE_COMMANDS=YES
export CPM_USE_LOCAL_PACKAGES=NO

export hostSystemName=$(shell uname)

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check format test

all: .init # conan
	cmake --workflow --preset dev # XXX --fresh
	# FIXME: gcovr -v

check: all
	-run-clang-tidy -p build/dev
	-iwyu_tool -p build/dev/ *.cpp -- -Xiwyu --cxx17ns

.init: .CMakeUserPresets.json
	# TODO: jrsonnet --preserve-order CMakeUserPresets.jsonnet > CMakeUserPresets.json ||
	perl -p -e 's/<hostSystemName>/${hostSystemName}/g;' .CMakeUserPresets.json > CMakeUserPresets.json
	mkdir -p build/coverage/
	touch .init

conan: conanfile.py GNUmakefile
	conan profile detect -f
	conan install . -s build_type=$(BUILD_TYPE) -s compiler.cppstd=20 -b missing

clean:
	rm -rf build example/build

distclean: clean
	rm -rf conan stagedir .init CMakeUserPresets.json
	# XXX NO! git clean -xdf

format: distclean
	find . -name CMakeLists.txt -o -name '*.cmake' | xargs cmake-format -i
	git clang-format master

# Anything we don't know how to build will use this rule.
# The command is a do-nothing command.
#
% :: ;
