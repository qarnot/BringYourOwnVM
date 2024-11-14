#include <stdio.h>

int main(void)
{
    unsigned long fibo1 = 0;
    unsigned long fibo2 = 1;

    unsigned long tmp = 0;
  
    for (unsigned i = 0; i < 94; i++)
    {
        printf("%u: %lu\n", i, fibo1);
        tmp = fibo1;
        fibo1 = fibo2;
        fibo2 = fibo1 + tmp;
    }

    return 0;
}
