import std; // When importing std.compat it's not needed to import std.
import std.compat;

int main() {
  std::cout << "Hello modular world\n";
  ::printf("Hello compat modular world\n");
}
