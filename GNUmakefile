# Standard stuff

.SUFFIXES:
$(VERBOSE).SILENT:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

# export CC=gcc-13
# export CXX=g++-13
export CC=clang-17
export CXX=$(shell which clang++)
export CMAKE_EXPORT_COMPILE_COMMANDS=YES

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check format test

all: conan
	# TODO: if needed: cmake --preset dev --fresh --debug-find-pkg=fmt
	cmake --workflow --preset dev # XXX --fresh
	cmake --install build/dev --prefix $(CURDIR)/stagedir
	# TODO: cpack --list-presets

test: all
	cd example && cmake -B build -S . -G Ninja -D CMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-D 'CMAKE_PREFIX_PATH=$(CURDIR)/stagedir;$(CURDIR)/conan' \
		--toolchain $(CURDIR)/conan/conan_toolchain.cmake --debug-find-pkg=fmt
	ninja -C example/build
	ninja -C example/build test

check: test
	-run-clang-tidy -p build/dev

conan: conanfile.py GNUmakefile
	conan profile detect -f
	conan install . -s build_type=$(BUILD_TYPE) -s compiler.cppstd=20 -b missing

clean:
	rm -rf build

distclean:
	rm -rf conan stagedir
	# XXX NO! git clean -xdf

format:
	find . -name CMakeLists.txt -o -name '*.cmake' | xargs cmake-format -i
	git clang-format master
