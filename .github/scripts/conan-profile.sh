#!/bin/bash

set -e
set -u
set -x

pip3 install --upgrade pip || echo ignored
pip3 install conan cmake ninja gcovr || echo ignored

which conan
conan --version
conan profile detect --force

std=20
if [ "$RUNNER_OS" = Windows ]; then
  std=20
fi

profile="$(conan profile path default)"

mv "$profile" "${profile}.bak"
sed 's/^\(compiler\.cppstd=\).\{1,\}$/\1'"$std/" "${profile}.bak" > "$profile"
rm "${profile}.bak"
