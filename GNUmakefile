# Standard stuff

.SUFFIXES:
$(VERBOSE).SILENT:

MAKEFLAGS+= --no-builtin-rules	# Disable the built-in implicit rules.
MAKEFLAGS+= --warn-undefined-variables	# Warn when an undefined variable is referenced.
MAKEFLAGS+= --include-dir=$(CURDIR)/conan	# Search DIRECTORY for included makefiles (*.mk).

.PHONY: all clean distclean check format

all: conan
	cmake --workflow --preset dev # --fresh
	cmake --build --preset dev --target install

check:all
	-run-clang-tidy -p build/dev

conan: conanfile.py
	-conan install . -s build_type=Debug -b missing

clean:
	rm -rf build

distclean:
	rm -rf conan stagedir
	# git clean -xdf

format:
	find . -name CMakeLists.txt -o -name '*.cmake' | xargs cmake-format -i
	git clang-format master
