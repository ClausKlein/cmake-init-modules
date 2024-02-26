# Standard stuff

.SUFFIXES:
$(VERBOSE).SILENT:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

# export CC=gcc-13
# export CXX=g++-13
export CC=clang-17
export CXX=clang++-17
export CMAKE_EXPORT_COMPILE_COMMANDS=YES

CONAN_HOME=$(shell conan config home)
# BUILD_TYPE=Release
BUILD_TYPE=Debug

.PHONY: all clean distclean check format

all: conan
	# TODO: if needed: cmake --preset dev --fresh --debug-find-pkg=fmt
	cmake --workflow --preset dev # XXX --fresh
	cmake --install build/dev --prefix $(CURDIR)/stagedir
	# TODO: cpack --list-presets

check:all
	-run-clang-tidy -p build/dev

conan: conanfile.py GNUmakefile
	conan profile detect -f
	# test -e $(CONAN_HOME)/profiles/clang-17 || cp -n $(CONAN_HOME)/profiles/default $(CONAN_HOME)/profiles/clang-17
	test -e $(CONAN_HOME)/profiles/${CC} || \
	  perl -p -e 's/(compiler.cppstd)=.*$$/$$1=20/;' -e 's/(build_type)=.*$$/$$1=$(BUILD_TYPE)/;' \
	    $(CONAN_HOME)/profiles/default > $(CONAN_HOME)/profiles/${CC}
	conan install --profile ${CC} . -s build_type=$(BUILD_TYPE) -b missing

clean:
	rm -rf build

distclean:
	rm -rf conan stagedir
	# XXX NO! git clean -xdf

format:
	find . -name CMakeLists.txt -o -name '*.cmake' | xargs cmake-format -i
	git clang-format master
