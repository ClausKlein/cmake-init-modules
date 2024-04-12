# Standard stuff

.SUFFIXES:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
# MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
# MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

# export CC=gcc-13
# export CXX=g++-13
export CC?=clang-17
export CXX?=$(shell which clang++)
export CMAKE_EXPORT_COMPILE_COMMANDS=YES
export CPM_USE_LOCAL_PACKAGES=NO

export hostSystemName=$(shell uname)

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check format test

all: .init conan
	cmake --workflow --preset dev # XXX --fresh
	cmake --install build/dev --prefix $(CURDIR)/stagedir
	#FIXME: gcovr -v

test: all
	cd example && cmake -B build -S . -G Ninja -D CMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-D 'CMAKE_PREFIX_PATH=$(CURDIR)/stagedir;$(CURDIR)/conan' \
		--toolchain $(CURDIR)/conan/conan_toolchain.cmake # XXX --debug-find-pkg=fmt
	ninja -C example/build
	ninja -C example/build test

check: test
	-run-clang-tidy -p build/dev
	-iwyu_tool -p build/dev/ *.cpp -- -Xiwyu --cxx17ns

.init: .CMakeUserPresets.json
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
