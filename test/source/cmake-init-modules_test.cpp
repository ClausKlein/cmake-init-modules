#include <string>

#include "cmake-init-modules/cmake-init-modules.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("Name is cmake-init-modules", "[library]")
{
  auto const exported = exported_class {};
  REQUIRE(std::string("cmake-init-modules") == exported.name());
}
