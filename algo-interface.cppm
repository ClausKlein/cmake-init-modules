module;

#include <algo_export.h>  // <-- Generated header added to the global fragment

#ifdef HAS_IMPORT_STD
import std;
#else
#  include <string>  // for string
#  include <utility>  // for move
#endif

export module algo;

export class ALGO_EXPORT Algo
{
public:
  explicit Algo(std::string name)
      : m_name(std::move(name))
  {
  }
  void helloWorld();

private:
  std::string m_name;
};
