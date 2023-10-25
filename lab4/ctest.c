#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#define N 10

int16_t a[N], c, d;
uint8_t n = N, count = 0;

extern void asm_func();

// вариант 19
// кол-во отрицательных элементов
// с <= a[i] <= d

int main(void) {
	srand(time(NULL));
	printf("A = ");
	for(int i = 0; i < n; i++) {
		a[i] = -32768 + rand() % 65536;
		printf("%hd ", a[i]);
	}
	printf("\ninput c, d (-32768 to 32767): ");
	scanf("%hd %hd", &c, &d);
	asm_func();
	printf("count: %hhd\n", count);
	return 0;
};