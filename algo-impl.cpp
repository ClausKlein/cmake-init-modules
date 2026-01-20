module;

#ifdef HAS_IMPORT_STD
import std;
#else
#  include <print>
#endif

module algo;

void Algo::helloWorld()
{
  std::print("hello {}\n", m_name);
}
