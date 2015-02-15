#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <random>
#include <vector>

using Elem = std::uint64_t;

#ifdef USE_SET
#include <set>
template<typename T>
using Set = std::set<T>;
#endif

#ifdef USE_AVL
#include "moon_avl/avl_tree.h"
template<typename T>
using Set = avl_tree<T>;
#endif

#ifdef USE_BTREE
#include "cpp-btree/btree_set.h"
template<typename T>
using Set = btree::btree_set<T>;
#endif

int main(int argc, char **argv)
{
  if (argc != 2) return EXIT_FAILURE;
  std::size_t num_elements = std::strtoull(argv[1], nullptr, 10);

  std::mt19937 engine;
  std::uniform_int_distribution<Elem> dist;

  std::vector<Elem> input;
  input.reserve(num_elements);
  for (std::size_t i = 0; i != num_elements; ++i) input.push_back(dist(engine));

  auto start = std::chrono::steady_clock::now();

  Set<Elem> set;
  for (auto i : input) set.insert(i);

  auto stop = std::chrono::steady_clock::now();

  std::sort(input.begin(), input.end());
  input.erase(std::unique(input.begin(), input.end()), input.end());
  if (input.size() != num_elements) {
    std::cout << "dup detected\n";
    return EXIT_FAILURE;
  }

  if (!std::equal(input.begin(), input.end(), set.begin())) {
    std::cout << "set failure\n";
    return EXIT_FAILURE;
  }
  auto ns = std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start);
  std::cout << ns.count() / 1000000.0 << "ms\n";
}
