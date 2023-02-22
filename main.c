#include "./libRA.c"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

extern int max(int *arr, unsigned int len);

/*
 * Explanation:
 * Since we are compiling without a C standard library, we use _start instead of main
 * as an entry point. The library functions exit, hex, rand, srand, println are defined
 * in libRA.c and partly implemented in libRA.S. The individual files will be
 * merged when linking (see Makefile).
 */
void _start()
{
  int size = 100;
  int *random_data = (int*)calloc(size, sizeof(int));
  
  if (random_data == NULL) {
    println("Failed to allocate memory for random data.");
    exit(1);
  }

  srand(time(NULL));

  println("Initialize array with random data.");
  for (int c = 0; c < size; c++)
  {
    int num = (int)rand();
    random_data[c] = num;
    hex(num);
  }

  int max_element = max(random_data, size);

  println("\nThe maximum element is:");
  hex(max_element);

  free(random_data);
  exit(0);
}
