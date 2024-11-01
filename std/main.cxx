#include <string>

extern void hello_world(std::string const& name);

auto main(int /*argc*/, char* argv[]) -> int
{
  hello_world((argv[1] != nullptr) ? argv[1] : "Voldemort?");
  return 0;
}
