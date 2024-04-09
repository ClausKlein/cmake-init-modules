module;

// XXX #include <iostream>
#include <fmt/core.h>

module algo;

void Algo::helloWorld()
{
  // XXX std::cout << "hello " << m_name << "\n";
  fmt::print("hello {}\n", m_name);
}
