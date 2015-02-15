all: bench

CLANG_FLAGS = -std=c++11 -stdlib=libc++ -lc++abi
GCC_FLAGS = -std=c++11

COUNTS = 10 100 1000 10000 100000 1000000 10000000
REPS = 5

bench_avl_clang_opt3: bench.cpp
	clang++ -o bench_avl_clang_opt3 bench.cpp ${CLANG_FLAGS} -O3 -DUSE_AVL

bench_avl_clang_opt2: bench.cpp
	clang++ -o bench_avl_clang_opt2 bench.cpp ${CLANG_FLAGS} -O2 -DUSE_AVL

bench_set_clang_opt3: bench.cpp
	clang++ -o bench_set_clang_opt3 bench.cpp ${CLANG_FLAGS} -O3 -DUSE_SET

bench_set_clang_opt2: bench.cpp
	clang++ -o bench_set_clang_opt2 bench.cpp ${CLANG_FLAGS} -O2 -DUSE_SET

bench_btree_clang_opt3: bench.cpp
	clang++ -o bench_btree_clang_opt3 bench.cpp ${CLANG_FLAGS} -O3 -DUSE_BTREE

bench_btree_clang_opt2: bench.cpp
	clang++ -o bench_btree_clang_opt2 bench.cpp ${CLANG_FLAGS} -O2 -DUSE_BTREE

bench_avl_gcc_opt3: bench.cpp
	g++ -o bench_avl_gcc_opt3 bench.cpp ${GCC_FLAGS} -O3 -DUSE_AVL

bench_avl_gcc_opt2: bench.cpp
	g++ -o bench_avl_gcc_opt2 bench.cpp ${GCC_FLAGS} -O2 -DUSE_AVL

bench_set_gcc_opt3: bench.cpp
	g++ -o bench_set_gcc_opt3 bench.cpp ${GCC_FLAGS} -O3 -DUSE_SET

bench_set_gcc_opt2: bench.cpp
	g++ -o bench_set_gcc_opt2 bench.cpp ${GCC_FLAGS} -O2 -DUSE_SET

bench_btree_gcc_opt3: bench.cpp
	g++ -o bench_btree_gcc_opt3 bench.cpp ${GCC_FLAGS} -O3 -DUSE_BTREE

bench_btree_gcc_opt2: bench.cpp
	g++ -o bench_btree_gcc_opt2 bench.cpp ${GCC_FLAGS} -O2 -DUSE_BTREE

define bench	
	@for i in ${COUNTS}; do echo -n "$1 $$i: "; for j in {0..${REPS}}; do $2 $$i; done | sort -n | head -1; done
endef

bench: bench_avl_clang_opt3 bench_avl_clang_opt2 bench_set_clang_opt3 bench_set_clang_opt2 bench_btree_clang_opt3 bench_btree_clang_opt2 bench_avl_gcc_opt3 bench_avl_gcc_opt2 bench_set_gcc_opt3 bench_set_gcc_opt2 bench_btree_gcc_opt3 bench_btree_gcc_opt2
	$(call bench,clang avl -O2,./bench_avl_clang_opt2)
	$(call bench,clang avl -O3,./bench_avl_clang_opt3)
	$(call bench,clang set -O2,./bench_set_clang_opt2)
	$(call bench,clang set -O3,./bench_set_clang_opt3)
	$(call bench,clang btree -O2,./bench_btree_clang_opt2)
	$(call bench,clang btree -O3,./bench_btree_clang_opt3)
	$(call bench,gcc avl -O2,./bench_avl_gcc_opt2)
	$(call bench,gcc avl -O3,./bench_avl_gcc_opt3)
	$(call bench,gcc set -O2,./bench_set_gcc_opt2)
	$(call bench,gcc set -O3,./bench_set_gcc_opt3)
	$(call bench,gcc btree -O2,./bench_btree_gcc_opt2)
	$(call bench,gcc btree -O3,./bench_btree_gcc_opt3)
	$(call bench,clang avl -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_avl_clang_opt2)
	$(call bench,clang avl -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_avl_clang_opt3)
	$(call bench,clang set -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_set_clang_opt2)
	$(call bench,clang set -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_set_clang_opt3)
	$(call bench,clang btree -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_btree_clang_opt2)
	$(call bench,clang btree -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_btree_clang_opt3)
	$(call bench,gcc avl -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_avl_gcc_opt2)
	$(call bench,gcc avl -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_avl_gcc_opt3)
	$(call bench,gcc set -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_set_gcc_opt2)
	$(call bench,gcc set -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_set_gcc_opt3)
	$(call bench,gcc btree -O2 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_btree_gcc_opt2)
	$(call bench,gcc btree -O3 jemalloc,LD_PRELOAD=/usr/lib/libjemalloc.so ./bench_btree_gcc_opt3)

clean:
	rm -f bench_avl_clang_opt3 bench_avl_clang_opt2 bench_set_clang_opt3 bench_set_clang_opt2 bench_btree_clang_opt3 bench_btree_clang_opt2 bench_avl_gcc_opt3 bench_avl_gcc_opt2 bench_set_gcc_opt3 bench_set_gcc_opt2 bench_btree_gcc_opt3 bench_btree_gcc_opt2

.PHONY: clean all
