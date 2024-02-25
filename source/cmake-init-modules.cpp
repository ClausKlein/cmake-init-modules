#include <string>

#include "cmake-init-modules/cmake-init-modules.hpp"

#include <fmt/core.h>

exported_class::exported_class()
    : m_name {fmt::format("{}", "cmake-init-modules")}
{
}

auto exported_class::name() const -> char const*
{
  return m_name.c_str();
}
