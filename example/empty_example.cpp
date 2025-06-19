#include <print>

#include <cmake-init-modules/cmake-init-modules.hpp>

auto main() -> int
{
  std::println("{}", exported_class().name());
  return 0;
}
