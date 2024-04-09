module;

#include <algo_export.h>  // <-- Generated header added to the global fragment
#include <string>         // for string
#include <utility>        // for move

export module
    algo;  // <-- Annotation not currently required, but see discussion below

export class ALGO_EXPORT
    Algo  // <-- ALGO_EXPORT annotation added to the class definition
{
public:
  explicit Algo(std::string name) : m_name(std::move(name)) {}
  void helloWorld();

private:
    std::string m_name;
};
