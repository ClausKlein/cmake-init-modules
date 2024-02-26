#include <iostream>

#include <cmake-init-modules/cmake-init-modules.hpp>

auto main() -> int
{
  std::cout << exported_class().name() << std::endl;
  return 0;
}
