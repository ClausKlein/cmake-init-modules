#include <format>
#include <string>

#include "cmake-init-modules/cmake-init-modules.hpp"

exported_class::exported_class()
    : m_name {std::format("{}", "cmake-init-modules")}
{
}

auto exported_class::name() const -> char const*
{
  return m_name.c_str();
}
