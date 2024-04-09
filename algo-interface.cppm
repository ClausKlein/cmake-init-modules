module;

#include <algo_export.h>  // <-- Generated header added to the global fragment

export module
    algo;  // <-- Annotation not currently required, but see discussion below

export class ALGO_EXPORT
    Algo  // <-- ALGO_EXPORT annotation added to the class definition
{
public:
  void helloWorld();
};
