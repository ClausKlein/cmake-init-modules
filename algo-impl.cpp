module;

#include <version>

#if defined(__cpp_lib_print)
#  include <print>
using std::print;
#else
#  include <fmt/core.h>
using fmt::print;
#endif

module algo;

// FIXME(CK): import fmt;

void Algo::helloWorld()
{
  print("hello {}\n", m_name);
}
