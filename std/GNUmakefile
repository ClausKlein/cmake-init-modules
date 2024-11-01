UNAME:=$(shell uname)
ifeq (${UNAME},Darwin)
  export GNU_PREFIX:=$(shell brew --prefix gcc@14)
  export GNU_ROOT:=$(shell realpath ${GNU_PREFIX})
  #TODO: export CXX:=g++-14

  export LLVM_PREFIX:=$(shell brew --prefix llvm@19)
  export LLVM_ROOT:=$(shell realpath ${LLVM_PREFIX})
  export LDFLAGS+=-L${LLVM_ROOT}/lib/c++
  export PATH:=${LLVM_ROOT}/bin:${PATH}
  export CXX?=clang++
else ifeq (${UNAME},Linux)
  export LLVM_ROOT:=/usr/lib/llvm-18
endif

#TODO: export CXXFLAGS:=-std=c++23
export CMAKE_BUILD_TYPE:=Release

BUILD_SHARED_LIBS?=YES

.PHONY: all build install format clean distclean
all: build
	ninja -C build
	cd build && ctest --verbose

build: CMakeLists.txt #XXX stagedir
	cmake -G Ninja -S . -B build -D BUILD_SHARED_LIBS=$(BUILD_SHARED_LIBS) -D CMAKE_PREFIX_PATH=$(CURDIR)/stagedir --fresh #XXX --debug-find-pkg=Asio

# stagedir: asio-module/CMakeLists.txt GNUmakefile
# 	cmake -G Ninja -S asio-module -B build/asio -D CMAKE_INSTALL_PREFIX=$(CURDIR)/stagedir --fresh
# 	cmake --build build/asio
# 	cmake --install build/asio # --prefix stagedir

format:
	cmake-format -i CMakeLists.txt asio-module/CMakeLists.txt asio-module/AsioConfig.cmake.in

clean:
	rm -rf build

distclean: clean
	rm -rf stagedir __build
