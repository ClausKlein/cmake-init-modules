module;

import std;

export module none;

export void hello_world(std::string const& name)
{
  std::print("Hello World! My name is {}\n", name);
}
